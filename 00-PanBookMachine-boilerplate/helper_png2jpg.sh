#!/bin/bash
#
# * Converts all .png files inside the folder CONTENT/img into .jpg files
#
# The original files will be moved into the folder PROCESSED.
# The original file name remains intact but gets a suffix containing date and time
#
# Files MUST have the ending .png
#
# WARNING:
# This script will potentially overwrite files.
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

for f in CONTENT/img/*.png
do
    FILENAME=${f##*/}
    BASENAME=${FILENAME%.*}
    echo "mv ${f} PROCESSED/${BASENAME}-${NOW}.png"
    mv ${f} PROCESSED/${BASENAME}-${NOW}.png
    echo "convert PROCESSED/${BASENAME}-${NOW}.png CONTENT/img/${BASENAME}.jpg"
    convert PROCESSED/${BASENAME}-${NOW}.png CONTENT/img/${BASENAME}.jpg
done


