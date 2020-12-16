#!/bin/bash
#
# * Resizes the image to stay within 1000x1000 pixel
# * Aspect ratio remains intact 
# 
# The original files will be moved into the folder PROCESSED.
# The original file name remains intact but gets appended:
# * an info of the operation that was done after this copy was made
#   e.g. "pre_JPG2GREYSCALE"
# * a suffix containing date and time
#
# Files MUST have the ending .jpg
#
# WARNING:
# This script will potentially overwrite files.
# If there are files by the same name in the PROCESSED folder,
# they will be overwritten.
#
# YOU SHOULD NOT NEED TO EDIT ANYTHING IN THIS FILE
#
# configure your book creation process in the config file:
#
# CONFIG/book.conf
#
# For general improvements, please create pull requests
# only for changes inside the folder
# 00-PanBookMachine-boilerplate
#
###########################################################

NOW=`date '+%Y_%m_%d_%H_%M_%S'`;
COMMAND="RESIZE1000"

for f in CONTENT/img/*.jpg
do
    FILENAME=${f##*/}
    BASENAME=${FILENAME%.*}
    echo "mv ${f} PROCESSED/${BASENAME}-pre_${COMMAND}-${NOW}.jpg"
    mv ${f} PROCESSED/${BASENAME}-pre_${COMMAND}-${NOW}.jpg
    echo "convert -resize 1000x1000  PROCESSED/${BASENAME}-pre_${COMMAND}-${NOW}.jpg ${f}"
    convert -resize 1000x1000  PROCESSED/${BASENAME}-pre_${COMMAND}-${NOW}.jpg ${f}
done


