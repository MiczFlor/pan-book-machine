# pan-book-machine

A little hack to make formatted documents from markdown using PanDoc https://pandoc.org/

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
