#!/bin/bash

###########################################################
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

# clean files: remove all files with ~ at the end
find . -type f -name '*~' -exec rm -f '{}' \;

# The absolute path to the folder whjch contains all the scripts.
# Unless you are working with symlinks, leave the following line untouched.
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#########################################################
# Special variables 
# Now special variables, like the current date, will be replaces in the file and variable names (like book title)
# First we need to make copies of the metadata files to be used for replacement
cp CONFIG/metadata-info.yaml tmp/metadata-info.yaml
cp CONFIG/book.conf tmp/book.conf
# read original book.conf for date format
. "${PATHDATA}/CONFIG/book.conf"

# Available variables:

# %TODAY% & %TODAYFILE% => current date
# Change the variables LANG_LOCALE and DATE_FORMAT in the file CONFIG/book.conf
TODAY=$(LC_ALL=${LANG_LOCALE}.utf8 date +"${DATE_FORMAT}")
sed -i "s/%TODAY%/${TODAY}/g" tmp/metadata-info.yaml
sed -i "s/%TODAY%/${TODAY}/g" tmp/book.conf
TODAYFILE=$(LC_ALL=${LANG_LOCALE}.utf8 date +"${DATE_FORMAT_FILE}")
sed -i "s/%TODAYFILE%/${TODAYFILE}/g" tmp/metadata-info.yaml
sed -i "s/%TODAYFILE%/${TODAYFILE}/g" tmp/book.conf

# read book metadata / configuration
. "${PATHDATA}/tmp/book.conf"

#################################
# Prepare some parameter settings

if [ $NUMBERSECTIONS == "TRUE" ]; then
    paramNUMBERSECTIONS="--number-sections"
else
    paramNUMBERSECTIONS=""
fi

if [ $TOC == "TRUE" ]; then
    paramTOC="--toc -V toc-depth:${TOCDEPTH}"
else
    paramTOC=""
fi

if [ $CITATIONSUSE == "TRUE" ]; then
    if [ $CSLUSE == "TRUE" ]; then
        paramCSL="--csl ${CSLPATHREL}${CSLFILE}"
    else
        paramCSL=""
    fi
    paramCITE="--bibliography ${CITATIONSPATHREL}${CITATIONSFILE} --filter pandoc-citeproc ${paramCSL}"
else
    paramCITE=""
fi

# sed -i 's/%TargetBook%/'"${folderName}"'/' "${folderName}"/CONFIG/book.conf

#########################################################
# Merge all MD files into one
#
# 1. pandoc requires an empty line before starting a new chapter with #
# so we append two line breaks using sed
#
# 2. Replace strings with special vars in content and metadata 
# 
# 3. create intermediate file using --file-scope to avoid confusion of auto-identifiers
# see: https://github.com/jgm/pandoc/wiki/Pandoc-Tricks#repeated-footnotes-anchors-and-headers-across-multiple-files
#
# 4. Convert 

#########################################################
# 1. Merge markdown files with appended line breaks
for f in CONTENT/*.md ; do sed -e '$s/$/\n\n/' $f ; done > "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"

#########################################################
# 2. Replace strings with special vars in content and metadata 
sed -i "s/%TODAY%/${TODAY}/g" "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"
sed -i "s/%TODAYFILE%/${TODAYFILE}/g" "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"

#########################################################
# 3. Intermediate markdown file using --file-scope
# we render this file into CONTENT - to keep the relative paths in place
pandoc --file-scope -o "CONTENT/T-E-M-P-${BOOKFILENAME}.md" "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"

#########################################################
# 4. Convert 
# Now we move into the CONTENT folder to keep relative paths intact (img etc.)
cd CONTENT

# PDF
if [ $PDF == "TRUE" ]; then
echo "Generating PDF"
pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} ${paramCITE} --file-scope --pdf-engine=xelatex --from markdown+header_attributes -H ../CONFIG/header.tex --listings -o "../${BOOKFILENAME}.pdf" ../tmp/metadata-info.yaml ../CONFIG/metadata-pdf.yaml "T-E-M-P-${BOOKFILENAME}.md" 
fi

# EPUB
if [ $EPUB == "TRUE" ]; then
echo "Generating EPUB"
pandoc -s ${paramNUMBERSECTIONS} --file-scope ${paramCITE} --from markdown -o "../${BOOKFILENAME}.epub" ../tmp/metadata-info.yaml ../CONFIG/metadata-epub.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# Word DOCX
if [ $DOCX == "TRUE" ]; then
echo "Generating DOCX"
pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} --file-scope ${paramCITE} --from markdown -o "../${BOOKFILENAME}.docx" ../tmp/metadata-info.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# HTML snippet .htm
if [ $HTM == "TRUE" ]; then
echo "Making HTML snippet"
pandoc --file-scope ${paramCITE} --from markdown -o "../${BOOKFILENAME}.htm" ../tmp/metadata-info.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# HTML standalone .html
if [ $HTML == "TRUE" ]; then
echo "Generating HTML standalone"
pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} --file-scope ${paramCITE} --from markdown -o "../${BOOKFILENAME}.html" ../tmp/metadata-info.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# Markdown
if [ $MARKDOWN == "TRUE" ]; then
echo "Generating Markdown"
pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} --file-scope ${paramCITE} -t markdown --from markdown -o "../${BOOKFILENAME}.md" ../tmp/metadata-info.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# Plain Text
if [ $PLAINTXT == "TRUE" ]; then
echo "Generating Plain Text"
pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} --file-scope ${paramCITE} -t plain --from markdown -o "../${BOOKFILENAME}.txt" ../tmp/metadata-info.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# REMOVE temporary files
rm "T-E-M-P-${BOOKFILENAME}.md"
rm ../tmp/*
