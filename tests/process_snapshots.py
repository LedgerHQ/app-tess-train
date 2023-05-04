import cv2
import numpy as np
from PIL import Image, ImageOps
import os

# Image pre-processing parameters
# Image crop (left and right) margin.
NANO_IMAGE_CROP_MARGIN = 6  # pixels
# Image upscale factor.
NANO_IMAGE_UPSCALE_FACTOR = 2
# Aspect ratio threshold for non-text areas removal.
NANO_NON_TEXT_AREA_AR = 1.9
# Minimum non-text area dimension.
NANO_NON_TEXT_AREA_MIN = 5 * 5
# Margin around non-text areas when filling
# rectangle to hide them.
NANO_NON_TEXT_AREA_MARGIN = 2  # pixels

def _nano_remove_non_text_areas(image: Image) -> Image:
    array = np.array(image)
    # Convert the image to grayscale
    gray = cv2.cvtColor(array, cv2.COLOR_BGR2GRAY)
    # Apply some gaussian blur
    gray = cv2.GaussianBlur(gray, (9, 1), 0)
    # Apply thresholding to binarize the image
    _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)
    # Dilate the image to connect nearby text regions
    kernel_dilation = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 3))
    dilation = cv2.dilate(thresh, kernel_dilation, iterations=2)
    # Apply some erosion for more accurate contour detection
    kernel_erosion = np.ones((5, 5), np.uint8)
    erosion = cv2.erode(dilation, kernel_erosion, iterations=1)
    # Find contours in the image
    contours, hierarchy = cv2.findContours(erosion, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    # Remove non-text areas based on aspect ratio
    m = NANO_NON_TEXT_AREA_MARGIN
    for contour in contours:
        x, y, w, h = cv2.boundingRect(contour)
        ar = w / float(h)
        area = w * h
        # Fill white rectangles over non-text areas.
        if ar < NANO_NON_TEXT_AREA_AR and area > NANO_NON_TEXT_AREA_MIN:
            cv2.rectangle(array, (x - m, y - m), (x + w + m, y + h + m), (255, 255, 255), -1)
    return Image.fromarray(array)

def process_snapshots(input_dir, output_dir):
    # Create the output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # Loop through all PNG files in the input directory
    for filename in os.listdir(input_dir):
        if filename.endswith(".png"):
            # Open the image file
            input_path = os.path.join(input_dir, filename)
            image = Image.open(input_path)
            
            # Perform the image processing operations
            w, h = image.size
            c = NANO_IMAGE_CROP_MARGIN
            s = NANO_IMAGE_UPSCALE_FACTOR
            image = ImageOps.invert(image)
            image = image.crop((c, 0, w - c, h))
            image = image.resize((w * s, h * s))
            image = _nano_remove_non_text_areas(image)
            
            # Save the processed image with a unique name
            output_path = os.path.join(output_dir, f"{os.path.splitext(filename)[0]}_processed.png")
            image.save(output_path)
