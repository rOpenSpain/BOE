# Helper function
is_numeric <- function(x) {
  is.numeric(tryCatch(as.numeric(x), warning = function(w) {
    FALSE
  }))
}

#' Create the number for _sumario_
#'
#' Creates the id for a _sumario_ by the date it was published.
#' @param date Date of the _sumario_
#' @inheritParams retrieve_sumario
#' @return A character vector
#' @seealso The id is different from the CVE, which can be created with [sumario_cve()].
#' @family code generators
#' @export
#' @importFrom methods is
#' @examples
#' sumario_nbo(Sys.Date())
#' sumario_nbo(format(as.Date("2009/01/01", "%Y/%m/%d"), "%Y%m%d"), journal = "BORME")
sumario_nbo <- function(date, journal = "BOE") {
  if (is(date, "Date")) {
    date <- format(date, "%Y%m%d")
  }
  check_date(date)
  journal <- match.arg(journal, c("BOE", "BORME"))
  paste(journal, "S", date, sep = "-")
}

#' @describeIn sumario_nbo For compatibility with previous version
#' @export
sumario_xml <- function(date) {
  if (is(date, "Date")) {
    date <- format(date, "%Y%m%d")
  }
  check_date(date)
  date
}

#' Create the number of the _sumario_
#'
#' @param year Character or numeric value of the year of the summary in YYYY format.
#' @param number Number of the summary in NNN format.
#' @inheritParams retrieve_sumario
#' @return A character vector with the CVE of the _sumario_.
#' @seealso [sumario_nbo()] if you want to retrieve the _sumario_ by date and don't know the CVE.
#' @family code generators
#' @export
#' @examples
#' sumario_cve(2019, 242)
sumario_cve <- function(year, number, journal = "BOE") {
  # There are some sumarios from before 2009
  if (as.numeric(number) < 0 || as.numeric(number) > 1000) {
    stop("The number should be the in numeric format above 1.",
      call. = FALSE
    )
  }
  journal <- match.arg(journal, c("BOE", "BORME"))
  code <- paste(journal, "S", year, number, sep = "-")
  check_code(code)
  code
}

#' Elements: _disposici
