
# Helper function
add <- function(x) {
    paste0("-", x)
}

is_numeric <- function(x){
    tryCatch(as.numeric(x), warning = function(w){FALSE}, finally = TRUE)
}

#' Create the id for sumario
#'
#' @param date Date of the sumario
#' @inheritParams retrieve_sumario
#' @return A character vector
#' @seealso [sumario_nbo](sumario_nbo)
#' @family code generator
#' @export
#' @importFrom methods is
#' @examples
#' sumario_xml(Sys.Date())
#' sumario_xml(format(as.Date("2009/01/01", "%Y/%m/%d"), "%Y%m%d"))
sumario_xml <- function(date, journal = "BOE") {
    if (is(date, "Date")) {
        date <- format(date, "%Y%m%d")
    }
    if (nchar(date) != 8  & !is_numeric(date)) {
        stop("The date should be the in numeric YYYYMMDD format", call. = FALSE)
    }

    journal <- match.arg(journal, c("BOE", "BORME"))
    paste0(journal, add("S"), add(date))
}

#' Create the number of the sumario
#'
#' @param year Character or numeric value of the year of the summary in YYYY format.
#' @param number Number of the summary in NNN format.
#' @inheritParams retrieve_sumario
#' @return A character vector
#' @family code generator
#' @export
#' @examples
#' sumario_nbo(2019, 242)
sumario_nbo <- function(year, number, journal = "BOE") {
    if (nchar(year) != 4  & !is_numeric(year)) {
        stop("The year should be the in numeric YYYY format", call. = FALSE)
    }
    if (nchar(number) != 4  & !is_numeric(number)) {
        stop("The number should be the in numeric NNN format", call. = FALSE)
    }
    journal <- match.arg(journal, c("BOE", "BORME"))
    paste0(journal, add("S"), add(year), add(number))
}

#' @name element
#' @title Elements: *disposición* and *anuncio*
#'
#' @param year Character or numeric value of the year of the element in YYYY format.
#' @param number Character or numeric value of the element.
#' @return A character vector
NULL

elemento <- function(item = c("B", "A"), year, number) {
    item <- match.arg(item, c("B", "A"))
    if (nchar(year) != 4  & !is_numeric(year)) {
        stop("The year should be in numeric YYYY format", call. = FALSE)
    }
    if (nchar(number) > 6  & !is_numeric(number)) {
        stop("The year should be in numeric XXXXXX format", call. = FALSE)
    }
    paste0("BOE", add(item), add(year), add(number))
}

#' @describeIn element Create the number of the diposicion.
#' @family code generator
#' @export
#' @examples
#' disposicion(2019, 242)
disposicion <- function(year, number) {
    elemento(item = "A", year = year, number = number)
}

#' @describeIn element Create the number of the anuncio.
#' @family code generator
#' @export
#' @examples
#' anuncio(2019, 242)
anuncio <- function(year, number) {
    elemento(item = "B", year = year, number = number)
}
