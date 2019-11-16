

base_url <- "https://boe.es/"


# h <- httr::modify_url("https://boe.es/diario_boe/xml.php", query = c("id=BOE-S-20141006"))


# resp <- httr::GET(h, httr::content_type_xml())

# content(resp, "parsed")
is_xml <- function(resp) {
    if (httr::http_type(resp) != "application/xml") {
        stop("API did not return xml", call. = FALSE)
    }
    TRUE
}
is_json <- function(resp) {
    if (httr::http_type(resp) != "application/json") {
        stop("API did not return json", call. = FALSE)
    }
    TRUE
}

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

query_htm <- function(id) {
    force(base_url)
    httr::modify_url(base_url,
                     path = "diario_boe/text.php",
                     query = paste0("id=", id))
}

#' Query pdf
#'
#' Query for a pdf. Remember you must know the code and the date it
#' was published.
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
    modify_url(base_url, path = p)
}

