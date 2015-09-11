.onLoad = function(libname, pkgname){
    typesinfo <- new.env(parent = getNamespace("enumeratermd"))
    assign("Figure", list(), envir = typesinfo)
    assign("Table",  list(), envir = typesinfo)
    assign(".types", c("Figure", "Table"), envir = typesinfo)
}

.onAttach = function(libname, pkgname){
    evalq(knit_hooks$set(tab.cap = hook_tab.cap), envir = getNamespace('knitr'))
    packageStartupMessage('knitr hook "tab.cap" is now available')
}

.onDetach = function(libname){
    evalq(knit_hooks$set(tab.cap = NULL), envir = getNamespace('knitr'))
    packageStartupMessage('knitr hook "tab.cap" has been removed')
}
