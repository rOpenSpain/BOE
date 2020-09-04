
# Helper function
is_numeric <- function(x){
    tryCatch(as.numeric(x), warning = function(w){FALSE}, finally = TRUE)
}

#' Create the id for _sumario_
#'
#' @param date Date of the _sumario_
#' @inheritParams retrieve_sumario
#' @return A character vector
#' @seealso [sumario_nbo](sumario_nbo)
#' @family code generator
#' @export
#' @importFrom methods is
#' @examples
#' sumario_xml(Sys.Date())
#' sumario_xml(format(as.Date("2009/01/01", "%Y/%m/%d"), "%Y%m%d"), journal = "BORME")
sumario_xml <- function(date, journal = "BOE") {
    if (is(date, "Date")) {
        date <- format(date, "%Y%m%d")
    }
    if (nchar(date) != 8  & !is_numeric(date)) {
        stop("The date should be the in numeric YYYYMMDD format", call. = FALSE)
    }

    journal <- match.arg(journal, c("BOE", "BORME"))

    paste(journal, "S", date, sep = "-")
}

#' Create the number of the _sumario_
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
    paste(journal, "S", year, number, sep  ="-")
}

#' @name element
#' @title Elements: _disposición_ and _anuncio_
#'
#' @param year Character or numeric value of the year of the element in YYYY format.
#' @param number Character or numeric value of the element.
#' @return A character vector
#' @family code generator
NULL

elemento <- function(item = c("B", "A"), year, number) {
    item <- match.arg(item, c("B", "A"))
    if (nchar(year) != 4  & !is_numeric(year)) {
        stop("The year should be in numeric YYYY format", call. = FALSE)
    }
    if (nchar(number) > 6  & !is_numeric(number)) {
        stop("The year should be in numeric XXXXXX format", call. = FALSE)
    }
    paste("BOE", item, year, number, sep = "-")
}

#' @describeIn element Create the number of the diposicion.
#' @export
#' @examples
#' disposicion(2019, 242)
disposicion <- function(year, number) {
    elemento(item = "A", year = year, number = number)
}

#' @describeIn element Create the number of the anuncio.
#' @export
#' @examples
#' anuncio(2019, 242)
anuncio <- function(year, number) {
    elemento(item = "B", year = year, number = number)
}

#' Check code of documents
#'
#' Given an id check if it is valid.
#' @param id
#' @return A logical value.
#' @examples
#' check_code("BOE-S-2014-242"))
#' # Will fail:
#' # check_code("BOE-S-2014")
#' # check_code("BOE-S-20141221")
check_code <- function(id) {
    ids <- unlist(strsplit(id, "-", fixed = TRUE), FALSE, FALSE)
    if (!ids[1] %in% c("BORME", "BOE")) {
        stop("Journal does not match: got ", ids[1],
             " should be either BORME or BOE.", call. = FALSE)
    }
    if (ids[1] == "BOE" & length(ids) > 4) {
        stop("The code should have at most 3 '-' got more.", call. = FALSE)
    }
    if (ids[1] == "BOE" & length(ids) < 4) {
        stop("The code should have at most 3 '-'.", call. = FALSE)
    }

    if (!ids[2] %in% c("B", "A", "S")) {
        stop("The type of document does not match: got ", ids[2],
             " should be either A, B or S.", call. = FALSE)
    }
    if (!is_numeric(paste0(ids[3:length(ids)], collapse = ""))) {
        stop("After journal and type of document there only should be numbers.",
             call. = FALSE)
    }
    if (ids[2] == "S" & nchar(ids[3]) > 4) {
        stop("Got ", ids[3], " should be a year in numerical form.",
             call. = FALSE)
    }
    if (ids[2] == "A" & ids[1] == "BORME" & length(ids) > 5) {
        stop("Got ", ids[3], " should be a year in numerical.", call. = FALSE)
    }

    TRUE
}
