#' Retrieve the sumario
#'
#' Obtain a sumario and tidy it in a table.
#' @param date A Date of the *sumario*.
#' @param journal Either BOE or BORME.
#' @return A data.frame with one line for each publication.
#' @export
#' @seealso tidy_sumario to learn about the format of the output
#' @examples
#' \donttest{retrieve_sumario(Sys.Date())}
retrieve_sumario <- function(date, journal = "BOE") {

    if (!is(date, "Date") | (nchar(date) != 8  & !is_numeric(date))) {
        stop("The date should be the in numeric YYYYMMDD format", call. = FALSE)
    }
    journal <- match.arg(journal, c("BOE", "BORME"))

    tidy_sumario(get_xml(query_xml(sumario_xml(date, journal), journal = journal)))
}


#' Url to the publications
#'
#' Transform the date and publication code to the urls to the publications on pdf format.
#' @param sumario A tidy sumario.
#' @seealso [`retrieve_sumario`](retrieve_sumario) to obtain *sumarios*, and [tidy_sumario](tidy_sumario)
#' to know the expected input.
#' @export
#' @return A character vector with the urls to get the publications in pdf format.
#' @examples
#' \donttest{
#' sumario <- retrieve_sumario(Sys.Date())
#' url_publications(sumario[1:10, ])
#' }
url_publications <- function(sumario) {

    if (!is(sumario, "data.frame")) {
        stop("The expected input is a data.frame. See retrieve_sumario")
    }

    if (!all(c("date", "publication") %in% colnames(sumario))) {
        stop("The data.frame does not have publication and date columns.")
    }
    d <- sumario$date
    pub_code <- sumario$publication
    year <- format(d, "%Y")
    month <- format(d, "%m")
    day <- format(d, "%d")
    query_pdf(year, month, day, pub_code)
}

#' Open publications on the browser
#'
#' This function opens urls in your browser.
#' @inheritParams url_publications
#' @return A tab should open on your default browser with the pdf of the publications.
#' @export
#' @importFrom utils browseURL
#' @examples
#' \donttest{
#' sumario <- retrieve_sumario(Sys.Date())
#' url_publications(sumario[1:10, ])}
open_publications <- function(sumario) {
    urls <- url_publications(sumario)
    sapply(urls, browseURL)
    invisible(NULL)
}
