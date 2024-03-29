#' Retrieve the _sumario_
#'
#' Obtain a _sumario_ and tidy it in a table.
#' @param date A Date of the _sumario_.
#' @param journal Either BOE or BORME.
#' @return A data.frame with one line for each publication.
#' @family functions to retrieve documents
#' @export
#' @seealso [tidy_sumario] to learn about the format of the output
#' @examples
#' \donttest{retrieve_sumario(last_date_boe())}
retrieve_sumario <- function(date, journal = "BOE") {
    is_cve <- is.character(date) && (startsWith(date, "BOE") || startsWith(date, "BORME"))
    if (is_cve) {
        stop("You seem to have provided a cve: use retrieve_docment()",
             call. = TRUE)
    }
    check_date(date)
    journal <- match.arg(journal, c("BOE", "BORME"))
    sumario_nbo <- sumario_nbo(date, journal)

    tidy_sumario(get_xml(query_xml(sumario_nbo)))
}


#' Retrieve information of a publication
#'
#' Tidy data from any document published on the BOE and BORME from the
#' [BOE](https://boe.es).
#' @param cve Character with the code of the document.
#' @family functions to retrieve documents
#' @export
#' @examples
#' cve <- "BOE-A-2020-12109"
#' df <- retrieve_document(cve)
retrieve_document <- function(cve) {
    check_code(cve)
    ids <- strsplit(cve, split = "-", fixed = TRUE)[[1]]
    xml <- get_xml(query_xml(cve))

    # Check if is a sumario
    if (xml_name(xml) == "sumario") {
        return(tidy_sumario(xml))
    }

    # We only have all the elements from the BOE for the moment, not the BORME
    switch(ids[2],
           "A" = tidy_disposicion(xml),
           "B" = tidy_anuncio(xml))
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
#' sumario <- retrieve_sumario(last_date_boe())
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
#' \dontrun{
#' sumario <- retrieve_sumario(last_date_boe())
#' url_publications(sumario[1:10, ])}
open_publications <- function(sumario) {
    urls <- url_publications(sumario)
    lapply(urls, browseURL)
    invisible(NULL)
}
