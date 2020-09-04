#' Tidy _sumario_ from xml file
#'
#' Cleans in a tidy format the _sumario_ file
#' @param x A XML file.
#' @return A data.frame with one line for each publication.
#'  Including date, _sumario_ number, section, section text,
#'  departament, departament number, epigraph, brief text,
#'  publication code and number of pages of the pdf.
#' @export
#' @examples
#' id <- sumario_xml(format(as.Date("2017/10/02", "%Y/%m/%d"), "%Y%m%d"))
#' sumario_file <- get_xml(query_xml(id))
#' m <- tidy_sumario(sumario_file)
#'
#' head(m)
#' tail(m)
#' @importFrom xml2 xml_attr
#' @importFrom xml2 xml_child
#' @importFrom xml2 xml_find_all
#' @importFrom xml2 xml_parent
#' @importFrom xml2 xml_text
#' @importFrom xml2 xml_attrs
tidy_sumario <- function(x) {

    fechas <- xml_text(xml_find_all(x,  "./meta/fecha"))

    # No content
    col_names <- c("date", "sumario_nbo", "sumario_code", "section",
                   "section_number", "departament", "departament_etq",
                   "epigraph", "text", "publication", "pages")
    if (length(fechas) == 0 ) {
        warning("No data")
        m <- matrix(NA, ncol = 11, nrow = 0)
        colnames(m) <- col_names
        return(as.data.frame(m))
    }
    nbo <- xml_attr(xml_find_all(x,  "./diario"), "nbo")

    # Diario > section > Departamento > Epígrafe > Publicacion
    Diario <- xml_find_all(x, "//diario")

    Sumario_nbo <- xml_child(Diario, "sumario_nbo")
    sumario_nbo <- xml_attr(Sumario_nbo, "id")
    journal <- gsub("-.*", "", sumario_nbo)

    # Change the colnames based on the journal
    # Diario > section > Emisor > Publicacion
    # In case there are two summaries on the same day
    # This prevents a warning of condition has length > 1
    journal <- unique(journal)
    if (journal == "BORME") {
        col_names[grepl("departament", col_names)] <- c("emisor", "emisor_etq")
    }

    Publicaciones <- xml_find_all(x, "//item")

    pages <- xml_find_all(x, ".//seccion//urlPdf")
    pages <- xml_attr(pages, "numPag")
    publications_id <- xml_attr(Publicaciones, "id")
    publications_txt <- xml_text(xml_find_all(Publicaciones, "//item/titulo"))

    # Those that have epigrafe are recovered
    publi <- vapply(Publicaciones, recover_publication, character(5L))

    m <- cbind(fechas, nbo, sumario_nbo, t(publi),
               publications_txt, publications_id, pages)
    colnames(m) <- col_names
    m <- as.data.frame(m, stringsAsFactors = FALSE)
    m$pages <- as.numeric(m$pages)
    m$date <- as.Date(m$date, format = "%d/%m/%Y")
    # For easier documentations
    remove <- vapply(m, function(x){all(is.na(x))}, logical(1L))
    m[, !remove]
}

recover_publication <- function(x) {
    parent <- xml_parent(x)
    if (is.na(xml_attr(parent, "etq"))) {
        epigrafe <- xml_attr(parent, "nombre")
        parent <- xml_parent(parent)
    } else {
        epigrafe <- NA
    }


    departamento <- xml_attr(parent, "nombre")
    departamento_etq <- xml_attr(parent, "etq")

    seccion <- xml_parent(parent)
    seccion <- xml_attrs(seccion)
    c(seccion, departamento, departamento_etq, epigrafe)
}
