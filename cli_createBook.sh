#!/bin/bash

# The absolute path to the folder which contains this script
PATHDATA="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

clear

# ? Folder name ?
read -r -p "Type folder name for the book: " folderName

# ? Copy sample content ?
read -r -p "Do you want to create sample content [y/N]? " response
case "$response" in
    [yY][eE][sS]|[yY])
        sampeContent="YES"
        ;;
    *)
        sampeContent="NO"
        ;;
esac

# Create book folder
if [ ! -d "${folderName}" ]; then
    # Directory doesn't exist.
    mkdir "${folderName}"
    # Copy required scripts / files
    cp 00-PanBookMachine-boilerplate/cli_panbookmachine.sh "${folderName}"/
    cp 00-PanBookMachine-boilerplate/helper_html2md.sh "${folderName}"/
    mkdir "${folderName}"/CONTENT
    mkdir "${folderName}"/CONTENT/img
    mkdir "${folderName}"/CONFIG
    mkdir "${folderName}"/PROCESSED
    cp -R 00-PanBookMachine-boilerplate/CONFIG/* "${folderName}"/CONFIG/
    mkdir "${folderName}"/CITATIONS
    cp -R 00-PanBookMachine-boilerplate/CITATIONS/* "${folderName}"/CITATIONS/
    # replace book name with given folder name
    sed -i 's/Pan-Book-Machine Manual/'"${folderName}"'/' "${folderName}"/CONFIG/book.conf
    mkdir "${folderName}"/misc
    mkdir "${folderName}"/tmp
else
    echo
    echo "Folder '${folderName}' already exists. Exiting."
    exit
fi

# Copy sample content
if [ ${sampeContent} == "YES" ]; then
    echo "Copying sample content."
    cp -R 00-PanBookMachine-boilerplate/CONTENT/* "${folderName}"/CONTENT/
else
    echo "Not copying sample content."
fi
