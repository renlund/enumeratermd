#' @title Chunk Tag \code{tab.cap} Extension for package:knitr
#'
#' @description \pkg{knitr} hook functions are called when the corresponding
#'   chunk options are not \code{NULL} to do additional jobs beside the R code
#'   in chunks. \pkg{enumeratermd} provides the hook \code{tab.cap} which adds a
#'   Pandoc table caption after the chunk. It is meant to be analogous to chunk
#'   option \code{fig.cap}.
#'
#' @details the function hook_tab.cap is set as a hook in \pkg{knitr} when
#'   \pkg{enumeratermd} is attached (and removed when \pkg{enumeratermd} is
#'   detached). It writes a Pandoc identifier tag directly above a code chunk in
#'   the form \code{[chunk-<chunk-label>]} where \code{<chunk-label>} is the
#'   chunk label contained in \code{opts_current$get('label')}.
#'
#' @references \url{http://yihui.name/knitr/hooks#chunk_hooks}
#'
#' @param before,options,envir see references
#' @export

hook_tab.cap = function(before, options, envir){
    caption <- options$tab.cap
    if(!before) paste("Table: ", caption)
}

# '

typesinfo <- new.env(parent = getNamespace("enumeratermd"))
assign("Figure", list(), envir = typesinfo)
assign("Table",  list(), envir = typesinfo)
assign(".types", c("Figure", "Table"), envir = typesinfo)
