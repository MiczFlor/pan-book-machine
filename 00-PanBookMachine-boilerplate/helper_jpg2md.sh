#!/bin/bash
#
# This file creates a markdown file from all .jpg images in
# the folder CONTENT/img
# The markdown file will embed these images.
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

# ? File name for created md file ?
read -r -p "Filename please (without the .md ending): " fileNameMd

for f in CONTENT/img/*.jpg
do
    FILENAME=${f##*/}
    BASENAME=${FILENAME%.*}
    echo "![](img/${FILENAME})" >> "CONTENT/${fileNameMd}.md";
    echo "" >> "CONTENT/${fileNameMd}.md";
done


