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

# The absolute path to the folder which contains all the scripts.
# Unless you are working with symlinks, leave the following line untouched.
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# function to render documents
render_documents () {

    #########################################################
    # 2. Replace strings with special vars in content and metadata 
    sed -i "s/%TODAY%/${TODAY}/g" "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"
    sed -i "s/%TODAYFILE%/${TODAYFILE}/g" "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"
    
    #########################################################
    # 3. Intermediate markdown file using --file-scope (for merged document integrity)
    # we render this file into CONTENT - to keep the relative paths in place
    # WARNING: --file-scope is not run IF single files are generated, 
    # because the integrity of each file is assumed. If we were to run it,
    # the metadata YAML of the single file disappears.
    if [ $MERGE == "TRUE" ]; then
        pandoc --file-scope -o "CONTENT/T-E-M-P-${BOOKFILENAME}.md" "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"
    else
        cp "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md" "CONTENT/T-E-M-P-${BOOKFILENAME}.md"
    fi
    #########################################################
    # 4. Convert 
    # Now we move into the CONTENT folder to keep relative paths intact (img etc.)
    cd CONTENT

    # PDF
    if [ $PDF == "TRUE" ]; then
    echo "Generating PDF"
    pandoc -s ${paramTOC} ${paramTOF} ${paramTOT} ${paramNUMBERSECTIONS} ${paramCITE} --file-scope --pdf-engine=xelatex --from markdown+header_attributes -H ../CONFIG/header.tex --listings -o "../${BOOKFILENAME}.pdf" ${METADATAINFO} ../CONFIG/metadata-pdf.yaml "T-E-M-P-${BOOKFILENAME}.md" 
        # PDF small
        if [ $PDFsmall == "TRUE" ]; then
        echo "Generating small PDF"
        ghostscript -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile="../${BOOKFILENAME}-small.pdf" "../${BOOKFILENAME}.pdf"
        fi
        # PDF very small
        if [ $PDFtiny == "TRUE" ]; then
        echo "Generating very small PDF"
        ghostscript -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="../${BOOKFILENAME}-tiny.pdf" "../${BOOKFILENAME}.pdf"
        fi
    fi
    
    # EPUB
    if [ $EPUB == "TRUE" ]; then
    echo "Generating EPUB"
    pandoc -s ${paramNUMBERSECTIONS} --file-scope ${paramCITE} --from markdown -o "../${BOOKFILENAME}.epub" ${METADATAINFO} ../CONFIG/metadata-epub.yaml "T-E-M-P-${BOOKFILENAME}.md"
    fi
    
    # Word DOCX
    if [ $DOCX == "TRUE" ]; then
    echo "Generating DOCX"
    pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} --file-scope ${paramCITE} --from markdown -o "../${BOOKFILENAME}.docx" ${METADATAINFO} "T-E-M-P-${BOOKFILENAME}.md"
    fi
    
    # HTML snippet .htm
    if [ $HTM == "TRUE" ]; then
    echo "Making HTML snippet"
    pandoc --file-scope ${paramCITE} --from markdown -o "../${BOOKFILENAME}.htm" ${METADATAINFO} "T-E-M-P-${BOOKFILENAME}.md"
    fi
    
    # HTML standalone .html
    if [ $HTML == "TRUE" ]; then
    echo "Generating HTML standalone"
    pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} --file-scope ${paramCITE} --from markdown -o "../${BOOKFILENAME}.html" ${METADATAINFO} "T-E-M-P-${BOOKFILENAME}.md"
    fi
    
    # Markdown
    if [ $MARKDOWN == "TRUE" ]; then
    echo "Generating Markdown"
    pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} --file-scope ${paramCITE} -t markdown --from markdown -o "../${BOOKFILENAME}.md" ${METADATAINFO} "T-E-M-P-${BOOKFILENAME}.md"
    fi
    
    # Plain Text
    if [ $PLAINTXT == "TRUE" ]; then
    echo "Generating Plain Text"
    pandoc -s ${paramTOC} ${paramNUMBERSECTIONS} --file-scope ${paramCITE} -t plain --from markdown -o "../${BOOKFILENAME}.txt" ${METADATAINFO} "T-E-M-P-${BOOKFILENAME}.md"
    fi
    
    # REMOVE temporary files
    rm "T-E-M-P-${BOOKFILENAME}.md"
    cd ..
    rm tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md

}

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
TIMESTAMP=$(LC_ALL=${LANG_LOCALE}.utf8 date +"%Y%m%d-%H-%M-%S")

# read book metadata / configuration
. "${PATHDATA}/tmp/book.conf"

#################################
# Pre-process files

# Pre-process HTML files?
if [ $PPHTML == "TRUE" ]; then
    for f in CONTENT/*.html
    do
        echo "Generating Markdown for ${f} filename ${FILENAME} basename ${BASENAME}"
        FILENAME=${f##*/}
        BASENAME=${FILENAME%.*}
        pandoc -s -t markdown_github-raw_html --from html -o "CONTENT/${BASENAME}.md" ${f}
        # move original file to other folder
        mv ${f} PROCESSED/
    done
fi

#################################
# Prepare some parameter settings

if [ $NUMBERSECTIONS == "TRUE" ]; then
    paramNUMBERSECTIONS="--number-sections"
else
    paramNUMBERSECTIONS=""
fi

# table of contents
if [ $TOC == "TRUE" ]; then
    paramTOC="--toc -V toc-depth:${TOCDEPTH}"
else
    paramTOC=""
fi

# table of figures
if [ $TOF == "TRUE" ]; then
    paramTOF="-V lof"
else
    paramTOF=""
fi

# table of tables
if [ $TOT == "TRUE" ]; then
    paramTOT="-V lot"
else
    paramTOT=""
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
# 1. preparing md docs (append empty line, opt. merge)

echo Merge ${MERGE}

# Backup all MD files in one (TRUE or FALSE)
if [ $BACKUPMD == "TRUE" ]; then
    for f in CONTENT/*.md ; do sed -e '$s/$/\n\n/' "$f" ; done > "misc/Backup-MD_${TIMESTAMP}.md"
fi

# Merge files into one document (TRUE) or keep separate (FALSE)
if [ $MERGE == "TRUE" ]; then
    echo "Merge into single file"
    
    # We want the master metadata in the merged document
    METADATAINFO="../tmp/metadata-info.yaml"
    
    # 1. Merge markdown files with appended line breaks
    for f in CONTENT/*.md ; do sed -e '$s/$/\n\n/' "$f" ; done > "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"

    # Call function to render documents
    render_documents

else
    echo "Merge into separate files"
    
    # Each file can contain YAML metadata for pandoc. We don't want the master metadata in each document
    METADATAINFO=""

    for f in CONTENT/*.md
    do
        FILENAME=${f##*/}
        BASENAME=${FILENAME%.*}
        BOOKFILENAME=${BASENAME}
        echo "${f} filename ${FILENAME} basename ${BASENAME}"
        
        # copy single file to tmp
        cp "${f}" "tmp/T-E-M-P-${BOOKFILENAME}-intermediate.md"
        
        # Call function to render documents
        render_documents

    done
fi

# REMOVE temporary files
rm tmp/*

