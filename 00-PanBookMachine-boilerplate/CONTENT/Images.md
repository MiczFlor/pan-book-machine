
# Images (jpeg, png, tiff, bmp)

Depending on the output format, using images inside a document can create unexpected results.

TeX based PDFs for example do not place the image at the place where it's been specified in the text.
For better reading, the image is placed to fit the flow of the text - a nice intention that sometimes
results in a cluster of pages at the end of a chapter.

EPUB on the other hand places the images where intended, on your eReader this might result in half
empty pages, because the image is pushed to the next page.

HTML files will create relative paths like:

~~~
<img src="img/Plane-pexels-width1200.tiff" alt="" />
~~~
... and you need to make sure that the images will manually be placed in the relative folder.

However, here are a few images with different image formats. Live and learn.
 
![JPEG 1200x800px](img/Kitten-pexels-width1200.jpg)
 
![PNG 1200x800px](img/Work-pexels-width1200.png)
 
![TIFF 1200x800px (LZW compression)](img/Plane-pexels-width1200.tiff)

![BMP 28Bit 1200x800px](img/Tree-pexels-width1200.bmp)

![PDF with figure caption text, next page without such text.](img/PDF.example.pdf)

\pagebreak

\pagebreak

![](img/PDF.example.pdf)

![](img/PDF.A5LangExample.pdf)

![](img/PDF.example.pdf)
