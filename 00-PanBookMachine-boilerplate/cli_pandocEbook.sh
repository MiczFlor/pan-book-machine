#!/bin/bash

###########################################################
# 
# YOU SHOULD NOT NEED TO EDIT ANYTHING IN THIS FILE
#
# configure your book creation process in the config file:
#
# CONFIG/book.conf
#
###########################################################

# clean files: remove all files with ~ at the end
find . -type f -name '*~' -exec rm -f '{}' \;

# The absolute path to the folder whjch contains all the scripts.
# Unless you are working with symlinks, leave the following line untouched.
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# read book metadata / configuration
. "${PATHDATA}/CONFIG/book.conf"

#############################
# Merge all MD files into one
#
# 1. pandoc requires an empty line before starting a new chapter with #
# so we append two line breaks using sed
#
# 2. create intermediate file using --file-scope to avoid confusion of auto-identifiers
# see: https://github.com/jgm/pandoc/wiki/Pandoc-Tricks#repeated-footnotes-anchors-and-headers-across-multiple-files
#
# 3. Convert 


# 1. Merge markdown files with appended line breaks
for f in CONTENT/*.md ; do sed -e '$s/$/\n\n/' $f ; done > "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"

# 2. Intermediate markdown file using --file-scope
# we render this file into CONTENT - to keep the relative paths in place
pandoc --file-scope -o "CONTENT/T-E-M-P-${BOOKFILENAME}.md" "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"

# 3. Convert 
# Now we move into the CONTENT folder to keep relative paths intact (img etc.)

cd CONTENT

# PDF
if [ $PDF == "TRUE" ]
then
echo "Making PDF"
pandoc -s --file-scope --pdf-engine=xelatex --from markdown --listings -o "../${BOOKFILENAME}.pdf" ../CONFIG/metadata-info.yaml ../CONFIG/metadata-pdf.yaml "T-E-M-P-${BOOKFILENAME}.md" 
fi

# EPUB
if [ $EPUB == "TRUE" ]
then
echo "Making EPUB"
pandoc -s --file-scope --from markdown --listings  -o "../${BOOKFILENAME}.epub" ../CONFIG/metadata-info.yaml ../CONFIG/metadata-epub.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# Word DOCX
if [ $DOCX == "TRUE" ]
then
echo "Making DOCX"
pandoc -s  --toc --file-scope --from markdown --listings -o "../${BOOKFILENAME}.docx" ../CONFIG/metadata-info.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# HTML snippet .htm
if [ $HTM == "TRUE" ]
then
echo "Making HTML snippet"
pandoc --file-scope --from markdown --listings -o "../${BOOKFILENAME}.htm" ../CONFIG/metadata-info.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

# HTML standalone .html
if [ $HTML == "TRUE" ]
then
echo "Making HTML standalone"
pandoc -s  --toc --file-scope --from markdown --listings -o "../${BOOKFILENAME}.html" ../CONFIG/metadata-info.yaml "T-E-M-P-${BOOKFILENAME}.md"
fi

#pandoc -s --toc -o ${BOOKFILENAME}.tex 00metadata-info.yaml 00metadata-pdf.yaml Document-ALL.md --from markdown --template eisvogel --listings
#pandoc -s --toc -o ${BOOKFILENAME}.pdf 00metadata-info.yaml 00metadata-pdf.yaml Document-ALL.md --from markdown --template eisvogel --listings
#pandoc -s -o ${BOOKFILENAME}.pdf 00metadata-info.yaml 00metadata-pdf.yaml Document-ALL.md --from markdown --listings

#pandoc -s -o ${BOOKFILENAME}.epub 00metadata-info.yaml 00metadata-epub.yaml Document-ALL.md

# REMOVE temporary files
rm "T-E-M-P-${BOOKFILENAME}.md"
rm ../tmp/*
