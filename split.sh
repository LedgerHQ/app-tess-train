#!/bin/bash
SOURCE=$1
if [ -z "$SOURCE" ]
then
    SOURCE="./data/nano-font-ocr-ground-truth/"
fi
lang=eng
set -- "$SOURCE"*.png
for img_file; do
    echo -e  "\r\n File: $img_file"
    OMP_THREAD_LIMIT=1 tesseract "${img_file}" "${img_file%.*}" --psm 6  --oem 1 -l $lang -c page_separator='' hocr
    PYTHONIOENCODING=UTF-8 hocr-extract-images -b $SOURCE -p "${img_file%.*}"-%03d.exp0.tif  "${img_file%.*}".hocr 
done
find "$SOURCE" -name '*exp0.txt' -exec sh -c 'mv "$0" "$(echo "$0" | sed "s/exp0.txt/exp0.gt.txt/")"' {} \;
