#' @title Capions in rmarkdown
#' @description This function allows enumerated tables and figures in rmarkdown.
#'   In connection to a table or figure you use \code{rmd_cap} (or convenience
#'   functions \code{tab_cap} or \code{fig_cap}) to record a label and a number
#'   (within the \code{typesinfo} environment). Within the text you can then
#'   refer to them as \code{`r rmd_ref(<label>)`}.
#' @details The \code{rmd_cap}, and convinience functions \code{tab_cap} and
#'   \code{fig_cap}, keeps track of Figures and Tables. Use e.g. \code{fig.cap =
#'   fig_cap("My Caption", "myLabel")} in a chunk header and \code{`r
#'   rmd_ref("myLab")`} in your rmd document.
#' @param caption the caption
#' @param label the label you can refer to in the .rmd document. If \code{NULL}
#'   it will inherit the 'label' from the current chunk
#' @param type usually "Table" or "Figure". User do not have to care as you use
#'   \code{tab_cap} or \code{fig_cap}, which calls \code{rmd_cap} with this
#'   argument fixed
#' @note You might have to knit your document twice for it to work. Relative
#'   changes or insertions of tables/figures probably requires you to reset the
#'   information on table/figure enumeration so far (use
#'   \code{index_type_reset}).
#' @seealso \code{\link{rmd_ref}}
#' @export

rmd_cap <- function(caption, label, type = NULL){
    if(is.null(type)) stop("[rmd_cap] type cannot be NULL.")
    if(is.null(label)) label <- knitr::opts_current$get("label")
    index_type(label = label, caption = caption,
              type = type, chunk = knitr::opts_current$get("label"))
    ref <- rmd_ref(label, type = TRUE)
    paste0(ref, ": ", caption)
}

#' @describeIn rmd_cap Captions for tables
#' @export
tab_cap <- function(caption = "", label = NULL){
    rmd_cap(caption = caption, label = label, type = "Table")
}

#' @describeIn rmd_cap Captions for figures
#' @export
fig_cap <- function(caption = "", label = NULL){
    rmd_cap(caption = caption, label = label,  type = "Figure")
}

# ' @title
# ' @description More things than necesary are currently stored.
# ' @param label,caption,type,chunk

index_type <- function(label, caption, type, chunk){
    type_val <- get(type, typesinfo)
    N <- length(type_val)
    if(is.null(type_val[[label]])){
        type_val[[label]] <- c('label'   = label,
                               'caption' = caption,
                               'number'  = N+1,
                               'type'    = type,
                               'chunk'   = chunk)
    }
    assign(type, type_val, envir = typesinfo)
}

#' @title Reset function
#' @description Reset environment \code{typesinfo}
#' @export

index_type_reset <- function(){
    .types <- get(".types", envir = typesinfo)
    for(t in .types){
        assign(t, list(), envir = typesinfo)
    }
}

#' @title Add type
#' @description Add a type different from "Figure" and "Table" to
#'   \code{typesinfo}
#' @param new_type name of new type
#' @export

add_index <- function(new_type){
    if(!is.character(new_type) | length(new_type) != 1){
        stop("new_type should be a character vector on length 1")
    }
    .types <- get(".types", envir = typesinfo)
    assign(".types", c(.types, new_type), envir = typesinfo)
    assign(new_type, list(), envir = typesinfo)
}

#' @title Get reference number
#' @description Get the refenrence number associated with a label
#' @param label a label
#' @param type look in "table" or "figure" (if \code{NULL} look everywhere)
#' @param unknown text if nothing found
#' @export

rmd_ref <- function(label, type = TRUE, unknown = "*<_unset reference_>*"){
    #if(!is.null(type)){
    #    L <- get(type, envir = typesinfo)
    #    info <- L[[label]]
    #    if(!is.null(info)) {
    #        ret <- info['number']
    #    }
    #} else {
    .types <- get(".types", envir = typesinfo)
    ret <- NULL
    for(t in .types){
        L <- get(t, envir = typesinfo)
        info <- L[[label]]
        if(!is.null(info)){
            ret <- info['number']
            the_type <- t
            break
        }
    }
    #}
    if(is.null(ret)) unknown else if(type) paste(the_type, ret) else ret
}

#' @title List of <types>
#' @description Create List of Tables, Figures, etc.
#' @param types what types do you want list for? (if \code{NULL} all)
#' @export

list_of <- function(types = NULL){
    if(is.null(types)) types <- get(".types", envir = typesinfo)
    out <- setNames(rep(NA_character_, length(types)), types)
    for(t in types){
        L <- get(t, envir = typesinfo)
        fnc <- function(x) paste(" -", x['number'], x['caption'], "\n")
        out[t] <- paste0("\n*",t,"*\n\n", paste(lapply(L, fnc), collapse = ""))
    }
    cat(paste0(out, collapse = ""))
}
