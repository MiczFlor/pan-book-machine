#!/bin/bash
#
# This file converts all .png files inside the folder CONTENT/img
# into .jpg files
# files MUST have the ending .png
#
# WARNING:
# This script will potentially overwrite files. If you have the
# scripts appendix.html and appendix.md in the CONTENT folder,
# it will read appendix.html, convert it to markdown and save
# it as appendix.md - thus overwriting the existing document.
#
# By default it will keep the html files in the folder.
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

for f in CONTENT/img/*.png
do
    FILENAME=${f##*/}
    BASENAME=${FILENAME%.*}
    echo "convert ${f} CONTENT/img/${BASENAME}.jpg"
    convert ${f} CONTENT/img/${BASENAME}.jpg
    echo "mv ${f} PROCESSED/"
    mv ${f} PROCESSED/
done


