---
title: 'Single file Pan-Book Machine Manual'
subtitle: 'Title rendered from file metadata'
author: 'Micz Flor'
publisher:  'https://github.com/MiczFlor/pan-book-machine/'
lang: 'de'
date: %TODAY%
...

# Why use (and how to configure) Pan-Book-Machine

Pan-Book-Machine was built to make it fairly easy to create good documents (PDF, ePUB, DOCX, HTML)
from markdown using the (great) PanDoc application.

The idea behind this set of scripts was:
* Render different output formats from the same source
* Configure metadata and global configuration for your book in one place
* Allow tweaking for different formats in a separate config file for each

Visit
[https://pandoc.org/MANUAL.html#pandocs-markdown](https://pandoc.org/MANUAL.html#pandocs-markdown) 
for more information on the PanDoc markdown.
Try clicking on this URL even if you are inside a PDF, it should open your browser.

You can also find a chapter at the end of this manual where I collect links regarding PanDoc
tutorials, tricks, information.

## Quickstart

### Start a new book

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

Your content lives in the folder `CONTENT`.
The files which will be used to render the book, must have the file ending `.md`.

**Including images**

If you want to use images in a subfolder, do so inside the `CONTENT` folder. 
`pan-book-machine` will work with relative paths from inside that folder.

## Special variables replaced on output creation

Sometimes you want to have dynamic changes in your final document when you create it.
The most common example: inserting the current date.

There are a number of variables which can be used. Here a list with info.

IMPORTANT: when using these variables, drop the backslash. The backslash has only been added so that the generated files will not dynamically replace the variable in this documentation. Example: "`\%TODAY\%`" is actually "`percent-TODAY-percent`".

**Date formats**

There are two date variables available:

* `\%TODAYFILE\%` is the more mechanical looking, e.g. `20200131` (January 31st, 2020)
* `\%TODAY\%` is human readable, e.g. `01. Juli 2020` (July 1st, 2020 in German)
    * Both date formats can be customised in the `book.conf` file.
    * Here you also have to set the language, e.g. `LANG_LOCALE="de_DE"` for German.
    * You can use these variables in all your content, inside `metadata-info.yaml` and `book.conf` (e.g. to add the current date to the filename)

## Create formatted book

**Inside your book folder, run the command:**

~~~
./cli_pandocEbook.sh
~~~

The resulting files will be placed in the book directory. 

## Configuring Pan-Book-Machine

The *global* configuration for all books can be found in the two files:

* `CONFIG/book.conf`
* `CONFIG/metadata-info.yaml`

These two files contain information that affect *ALL* output formats (such as file name or title of the book).
The only exception is the *table of contents* variable `TOCDEPTH` which only affects PDF / LaTeX. 
But I wanted to keep this close to the global TOC setting, which decides IF there is a table of contents at all.

There are a number of format specific configuration files such as:

* `CONFIG/metadata-pdf.yaml`
* `CONFIG/metadata-epub.yaml`

## Single file or multiple files?

There are two options of generating *a* book - or many single documents.
Inside `CONFIG/book.conf` you can set the variable `MERGE` to achieve the following:

*MERGE is "TRUE"*

All the markdown files with an ending `.md` are merged into one big file in alphanumerical order.

Then this one master file is used to create the book.

*MERGE is "FALSE"*

A single document is being created from every file ending with `.md`.
The created file has the same filename as the `.md` file.
The new file ending will - obviously - correspond to the output format.

**IMPORTANT**:
If you chose to create single files, you can add the metadata for each file in the head of the `.md` document.
If you do not add any, there will be no meta information in the created output format.
You can use the variables listed below to be replaced when running PanBookMachine.

This file, for example, contains the metadata:

~~~
---
title: 'Single file Pan-Book Machine Manual'
subtitle: 'Title rendered from file metadata'
author: 'Micz Flor'
publisher:  'https://github.com/MiczFlor/pan-book-machine/'
lang: 'de'
date: %TODAY%
...
~~~

## ePUB cover (e-book)

Creating an ePUB for eReaders allows to specify a cover image. 
And I suggest you do, because it makes it easier to find in your eReader.
Currently, Pan-Book-Machine expects the file:

* `CONFIG/coverEpub.jpg`

If you want to replace the cover image in our ePUB, replace this image.
If you do not want a cover image, open the file:

* `CONFIG/metadata-epub.yaml`

Delete the line:

~~~
cover-image: ../CONFIG/coverEpub.jpg
~~~

... or change it into some non-sensical variable by adding a hash:

~~~
#cover-image: ../CONFIG/coverEpub.jpg
~~~

NOTE: while JPEG is not officially an ePUB file format for images (PNG is), all readers support this format and the files are much smaller.

## Document language

Settings the language is important because:
* hyphenation at the end of the line (in e.G. PDF)
* additional wording (like "Contents" or "Figure" in PDF)

The language can (and should) be set inside the file `CONFIG/metadata-info.yaml`

~~~
lang: 'en'
~~~

See PanDoc Manual for more information: [https://pandoc.org/MANUAL.html#language-variables](https://pandoc.org/MANUAL.html#language-variables)

### Smart quotes in TeX

It's possible to include `{csquotes}` in the yaml metadata block for PDF.
Below is an example which would need to be added in the file 
`CONFIG/metadata-pdf.yaml`.

~~~
header-includes:
    - \usepackage{csquotes}
~~~

The language MUST be set in the same file, e.g. like this for German:

~~~
lang: "de"
~~~

or this, it's also German:

~~~
lang: "de-DE"
~~~

Does it work? 
"Here is an example" or another one 'here'. Let's see the single quote inside a word (beginning of this sentence).

And what if there " is a space " between letters and double quotes?

## Images

You can find more information on images in the file:

* `CONTENT/Images.md.off`

Rendering PDFs with images takes much more CPU and longer than text-only books.
This is why the file is named `Images.md.off`.
Because this file has the file ending `off` it does not show up in the created book if you run the script.

If you want to play with images, create a new book with the sample content 
using the instructions in the **Quickstart** section above.
Then rename `Images.md.off` to `Images.md` and create the book.

