# Footnotes and Citations 

## Footnotes

Here is a footnote reference,[^fn1] and another with multiple blocks.[^longnote]
Here is a short footnote reference,[^fn2] and another with multiple blocks.[^longnote]
Here is a short footnote reference,[^fn3] and another.[^fn4]

[^fn1]: Here is the footnote.
[^fn2]: Two footnote.
[^fn3]: The third footnote.
[^fn4]: Four your eyes only: here is the footnote.

[^longnote]: Here's one with multiple blocks.\
A second line, carriage return via backslash.

    Subsequent paragraphs are indented to show that they
belong to the previous footnote.

    The whole paragraph can be indented, or just the first
    line.  In this way, multi-paragraph footnotes work like
    multi-paragraph list items.

This paragraph won't be part of the note, because it
isn't indented.

## Citations (using citeproc-hs) 

Pandoc's citation processing is designed to allow you to
move between author-date, numerical, and note styles without
modifying the markdown source.  When you're using a note
style, avoid inserting footnotes manually. Instead, insert
citations just as you would in an author-date style---for
example,

    Blah blah [@foo, p. 33].

The footnote will be created automatically. Pandoc will take
care of removing the space and moving the note before or
after the period, depending on the setting of
`notes-after-punctuation`, as described below in [Other relevant
metadata fields].

In some cases you may need to put a citation inside a regular
footnote.  Normal citations in footnotes (such as `[@foo, p.
33]`) will be rendered in parentheses.  In-text citations (such
as `@foo [p. 33]`) will be rendered without parentheses. (A
comma will be added if appropriate.)  Thus:

    [^1]:  Some studies [@foo; @bar, p. 33] show that
    frubulicious zoosnaps are quantical.  For a survey
    of the literature, see @baz [chap. 1].

**Bibliography Placement:**

Find information about BibTex and the .bib file format here: [http://www.bibtex.org/](http://www.bibtex.org/)

Bibliographies will be placed at the end of the document. Normally, you will want to end your document with an appropriate header:

~~~
last paragraph...

# References
~~~

The bibliography will be inserted after this header.

Here are a few examples to illustrate how *citations* will show up inline:


-   @item1 says blah.

-   @item1 [p. 30] says blah.

-   @item1 [p. 30, with suffix] says blah.

-   @item1 [-@item2 p. 30; see also @item3] says blah.

-   In a note.[^1]

[^1]: A citation without locators [@item3].

-   A citation group [see @item1 p. 34-35; also @item3 chap. 3].

-   Another one [see @item1 p. 34-35].

-   And another one in a note.[^2]

[^2]: Some citations [see @item2 chap. 3; @item3; @item1].

-   Citation with a suffix and locator [@item1 pp. 33, 35-37, and nowhere else].

-   Citation with suffix only [@item1 and nowhere else].

-   Now some modifiers.[^3]

[^3]: Like a citation without author: [-@item1], and now Doe with a locator [-@item2 p. 44].

-   With some markup [*see* @item1 p. **32**].
