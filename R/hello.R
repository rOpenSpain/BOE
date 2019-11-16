# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'
journal <- "BOE"

add <- function(x) {
    paste0("-", x)
}

summario <- function(code) {
    if (nchar(code) != 8  &!is_numeric(code)) {
        stop("The code should be the date in YYYYMMDD format", call. = FALSE)
    }
    paste0(journal, add("S"), add(code))
}

is_numeric <- function(x){
    tryCatch(as.numeric(x), warning = function(w){FALSE}, finally = TRUE)
}
