[![Travis-CI Build Status](https://travis-ci.org/renlund/enumeratermd.svg?branch=master)](https://travis-ci.org/renlund/enumeratermd)

enumeratermd
============

A package for enumerating tables and figures in rmarkdown documents.
It's easy enough:

 - `rmd_tab` produces a caption, records a label (chunk label as default) and assigns a number
 - `rmd_ref` retrieves the numbers

Also, a

 - `knitr` chunk hook `tab.cap` analogous to `fig.cap`
 - function to create list of tables/figures

(Update: I think the R package 'bookdown' solves these problems.)
