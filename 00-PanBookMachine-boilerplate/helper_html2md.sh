#!/bin/bash
#
# This file converts all html files inside the folder CONTENT
# into markdown files (.md).
# The html files MUST have the ending .html
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

for f in CONTENT/*.html
do
    FILENAME=${f##*/}
    BASENAME=${FILENAME%.*}
    echo "Generating Markdown for ${f} filename ${FILENAME} basename ${BASENAME}"
    pandoc -s -t markdown_github-raw_html --from html -o "CONTENT/${BASENAME}.md" ${f}
done


