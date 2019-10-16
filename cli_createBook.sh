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
    cp 00-PanBookMachine-boilerplate/cli_pandocEbook.sh "${folderName}"/
    mkdir "${folderName}"/CONTENT
    mkdir "${folderName}"/CONFIG
    cp -R 00-PanBookMachine-boilerplate/CONFIG/* "${folderName}"/CONFIG/
    # replace book name with given folder name
    sed -i 's/%TargetBook%/'"${folderName}"'/' "${folderName}"/CONFIG/book.conf
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
