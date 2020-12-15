#!/bin/bash
#
# This file creates a markdown file from all .jpg images in
# the folder CONTENT/img
# The markdown file will embed these images.
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

# ? File name for created md file ?
read -r -p "Filename please (without the .md ending): " fileNameMd


for f in CONTENT/img/*.jpg
do
    FILENAME=${f##*/}
    BASENAME=${FILENAME%.*}
    echo "![](img/${FILENAME})" >> "CONTENT/${fileNameMd}.md";
    echo "" >> "CONTENT/${fileNameMd}.md";
done


