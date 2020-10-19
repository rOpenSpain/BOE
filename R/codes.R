
# Helper function
is_numeric <- function(x){
    is.numeric(tryCatch(as.numeric(x), warning = function(w){FALSE}))
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
    check_date(date)
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
    # There are some sumarios from before 2009
    if (as.numeric(number) < 0 || as.numeric(number) > 1000) {
        stop("The number should be the in numeric format above 1.",
             call. = FALSE)
    }
    journal <- match.arg(journal, c("BOE", "BORME"))
    code <- paste(journal, "S", year, number, sep  ="-")
    check_code(code)
    code
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
    if (nchar(year) != 4  && !is_numeric(year)) {
        stop("The year should be in numeric YYYY format", call. = FALSE)
    }
    if (nchar(number) > 3  && !is_numeric(number)) {
        stop("The number should be in numeric XXX format", call. = FALSE)
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
#' @param id ID of the document (character).
#' @return A logical value.
#' @export
#' @examples
#' check_code("BOE-S-20141006") # Normal way
#' check_code("BOE-S-2014-242") # Also accepted but not documented
#' # Will fail:
#' # check_code("BOE-S-2014")
check_code <- function(id) {
    if (length(id) > 1) {
        stop("This function is not vectorized. Check the code one by one.",
             call. = FALSE)
    }
    ids <- unlist(strsplit(id, "-", fixed = TRUE), FALSE, FALSE)
    if (!ids[1] %in% c("BORME", "BOE")) {
        stop("Journal does not match: got ", ids[1],
             " should be either BORME or BOE.", call. = FALSE)
    }
    if (ids[1] == "BOE" && length(ids) > 4) {
        stop("The code should have at most 3 '-' got more.", call. = FALSE)
    }
    if (ids[1] == "BOE" && !ids[2] %in% c("B", "A", "S")) {
        stop("The type of document does not match: got ", ids[2],
             " should be either A, B or S.", call. = FALSE)
    }
    if (ids[1] == "BORME" && !ids[2] %in% c("B", "A", "C", "S")) {
        stop("The type of document does not match: got ", ids[2],
             " should be either A, B, C or S.", call. = FALSE)
    }
    # BORME-S-2017-188 and BORME-S-20171002 are equivalent
    if (length(ids) < 4 && ids[2] != "S") {
        stop("The code should have three 3 '-'.", call. = FALSE)
    }
    if (length(ids) < 4 && ids[2] == "S" && nchar(ids[3]) < 8) {
        stop("The last number should be a date of format YYYYMMDD.", call. = FALSE)
    }
    if (length(ids) < 4 && ids[2] == "S" && nchar(ids[3]) >= 8) {
        check_date(ids[3])
    }

    if (!is_numeric(paste0(ids[3:length(ids)], collapse = ""))) {
        stop("After journal and type of document there only should be numbers.",
             call. = FALSE)
    }
    # if (ids[2] == "S" && nchar(ids[3]) > 4) {
    #     stop("Got ", ids[3], " should be a year in numerical form.",
    #          call. = FALSE)
    # }
    if (ids[2] == "A" && ids[1] == "BORME" && length(ids) > 5) {
        stop("Got ", ids[3], " should be a numerical year.", call. = FALSE)
    }

    TRUE
}

check_date <- function(x) {
    if (!is.na(as.Date(x, format = "%Y%m%d"))) {
        return(TRUE)
    }
    y <- strsplit(x, "")[[1]]
    month <- as.numeric(paste0(y[5:6], collapse = ""))
    day <- as.numeric(paste0(y[7:8], collapse = ""))
    if (month >= 13) {
        stop("The month is greater than 12.", call. = FALSE)
    }
    if (day >= 31) {
        stop("The day is greater than 31.", call. = FALSE)
    }
    stop("That date does not exists, check the day of the month.",
         call. = FALSE)
}
