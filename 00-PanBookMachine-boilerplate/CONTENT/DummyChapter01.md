
# Dummy Chapter 01 Title

Visit
[https://pandoc.org/MANUAL.html#pandocs-markdown](https://pandoc.org/MANUAL.html#pandocs-markdown) 
for more information on the PanDoc markdown.
Try clicking on this URL even if you are inside a PDF, it should open your browser.

## Smart quotes in TeX

It's possible to include `{csquotes}` in the yaml metadata block for PDF.
Below is an example which would need to be added in the file 
`CONFIG/metadata-pdf.yaml`.

~~~
header-includes:
    - \usepackage[german=quotes]{csquotes}
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
