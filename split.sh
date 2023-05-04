#!/bin/bash
SOURCE="./data/nanox-font-ocr-ground-truth/"
lang=eng
set -- "$SOURCE"*.png
for img_file; do
    echo -e  "\r\n File: $img_file"
    # OMP_THREAD_LIMIT=1 tesseract --tessdata-dir tessdata_fast   "${img_file}" "${img_file%.*}"  --psm 6  --oem 1  -l $lang -c page_separator='' hocr
    OMP_THREAD_LIMIT=1 tesseract "${img_file}" "${img_file%.*}" --psm 6  --oem 1 -l $lang -c page_separator='' hocr
    # source venv/bin/activate
    PYTHONIOENCODING=UTF-8 hocr-extract-images -b $SOURCE -p "${img_file%.*}"-%03d.exp0.tif  "${img_file%.*}".hocr 
    # deactivate
done
rename s/exp0.txt/exp0.gt.txt/ $SOURCE*exp0.txt