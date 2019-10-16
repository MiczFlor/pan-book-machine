# pan-book-machine

A little hack to make formatted documents from markdown using PanDoc https://pandoc.org/

## Start a new book

To create a new book, **go into the `pan-book-machine` and type:**
~~~
./cli_createBook.sh
~~~

Here you can provide

* the folder name for the new book
* decide if you want sample content (possibly a good idea if you want to play with pan-doc-machine)

**No edit the file inside the newly created folder:**
~~~
CONFIG/book.conf
~~~

Each option (like PDF or DOCX you can set to TRUE or FALSE)

**Finally, edit the file:**
~~~
CONFIG/metadata-info.yaml
~~~
To make the output match your information (title and the like)

## Edit the content of your new book

All the markdown files with an ending `.md` are merged into one big file in alphanumerical order.

Then this one master file is used to create the book.

**Including images**

If you want to use images in a subfolder, do so inside the `CONTENT` folder. 
`pan-book-machine` will work with relative paths from inside that folder.

## Create formatted book

**Inside your book folder, run the command:**

~~~
./cli_pandocEbook.sh
~~~

The resulting files will be placed in the book directory. 

**DO NOT** edit the files in the folder `00-PanBookMachine-boilerplate` unless you want
to contribute new code to the git repo. All the files you need to edit are inside the folder of your
new book directory.

