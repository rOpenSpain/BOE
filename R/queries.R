

base_url <- "https://boe.es/"

#' Build a query for an XML
#'
#' @param id The id of the xml document you want.
#' @export
#' @examples
#' id <- sumario_xml(format(as.Date("2017/10/02", "%Y/%m/%d"), "%Y%m%d"))
#' query_xml(id)
#' @importFrom httr modify_url
query_xml <- function(id) {
    force(base_url)
    httr::modify_url(base_url,
                     path = "diario_boe/xml.php",
                     query = paste0("id=", id))
}

#' Build a query for the webpage
#'
#' @param id The id of the xml document you want.
#' @export
#' @examples
#' id <- sumario_nbo("2017", "11117")
#' query_htm(id)
query_htm <- function(id) {
    force(base_url)
    httr::modify_url(base_url,
                     path = "diario_boe/text.php",
                     query = paste0("id=", id))
}

#' Query a pdf from the BOE
#'
#' To query a pdf you must know the number of the piece you are looking for and
#' the date it was published.
#' @param year Character of the number of the year: YYYY
#' @param month Character of the number of the month: MM.
#' @param day Character of the number of the day: DD.
#' @param code Code of the publication to query.
#' @export
#' @examples
#' code <- sumario_nbo("2017", "237")
#' query_pdf("2017", "10", "02", code)
query_pdf <- function(year, month, day, code) {
    force(base_url)
    p <- paste("/boe/dias", year, month, day, "pdfs", paste0(code, ".pdf"), sep = "/")
    httr::modify_url(base_url, path = p)
}

