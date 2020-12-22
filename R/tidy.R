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
#' id <- sumario_nbo(format(as.Date("2017/10/02", "%Y/%m/%d"), "%Y%m%d"))
#' sumario_file <- get_xml(query_xml(id))
#' m <- tidy_sumario(sumario_file)
#'
#' head(m)
#' tail(m)
#' @importFrom xml2 xml_name
#' @importFrom xml2 xml_attr
#' @importFrom xml2 xml_child
#' @importFrom xml2 xml_children
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

# xml  <- get_xml(query_xml("BOE-B-2017-5"))
# tidy_anuncio(xml)
tidy_anuncio <- function(xml) {
    fecha_actualizacion <- xml_attr(xml, "fecha_actualizacion")
    fecha_actualizacion <- as.POSIXct(fecha_actualizacion,
                                      format = "%Y%m%d%H%M%S", tz = "CET")
    metadatos <- tidy_metadatos(xml_find_all(xml, "//metadatos"))
    metadatos$fecha_actualizacion <- fecha_actualizacion
    metadatos$analysis <- list(tidy_analysis(xml_child(xml, "analisis")))
    metadatos$text <- xml_text(xml_find_all(xml, "./texto"))
    metadatos$text_xml <- xml_find_all(xml, "./texto")
    metadatos
}

# xml  <- get_xml(query_xml("BOE-A-2017-5"))
# xml  <- get_xml(query_xml("BOE-A-2020-5796"))
# tidy_disposicion(xml)
tidy_disposicion <- function(xml) {
    fecha_actualizacion <- xml_attr(xml, "fecha_actualizacion")
    fecha_actualizacion <- as.POSIXct(fecha_actualizacion,
                                      format = "%Y%m%d%H%M%S", tz = "CET")
    metadatos <- tidy_metadatos(xml_child(xml, "metadatos"))
    metadatos$fecha_actualizacion <- fecha_actualizacion
    metadatos$analysis <- list(tidy_analysis(xml_child(xml, "analisis")))
    metadatos$text <- xml_text(xml_find_all(xml, "./texto"))
    metadatos$text_xml <- xml_find_all(xml, "./texto")
    metadatos
}

tidy_metadatos <- function(meta) {
    # Data about the document itself
    metas <- xml_children(meta)
    text <- as.list(xml_text(metas))
    names(text) <- xml_name(metas)
    text[["diario"]] <- xml_attr(xml_find_all(metas, "//diario"), "codigo")
    departamento <- xml_child(meta, "departamento")
    text[["departamento_codigo"]] <- xml_attr(departamento, "codigo")

    text[["fecha_publicacion"]] <- as.Date(text[["fecha_publicacion"]],
                                           "%Y%m%d")
    as.data.frame(text)
}

tidy_analysis <- function(analysis) {
    analysis <- xml_children(analysis)
    names <- xml_name(analysis)
    if (length(names) == 0) {
        return(NA)
    }
    analisis <- vector("list", length = length(names))
    names(analisis) <- names
    if ("notas" %in% names) {
        analisis[["notas"]] <- tidy_notas(xml_find_all(analysis, "//notas"))
    }
    if ("materias" %in% names) {
        analisis[["materias"]] <- tidy_materias(
            xml_find_all(analysis, "//materias"))
    }
    if ("alertas" %in% names) {
        analisis[["alertas"]] <- tidy_alertas(
            xml_find_all(analysis, "//alertas"))
    }
    if ("referencias" %in% names) {
        analisis[["referencias"]] <- tidy_referencias(
            xml_find_all(analysis, "//referencias"))
    }
    analisis
}


#' @importFrom xml2 xml_length
tidy_notas <- function(notas) {
    if (all(xml_length(notas) == 0 )) {
        return(NA)
    }
    notas <- xml_children(notas)
    m <- t(simplify2array(xml_attrs(notas), FALSE))
    m <- cbind(m, text = xml_text(notas))
    as.data.frame(m)
}
tidy_materias <- function(materias) {
    if (all(xml_length(materias) == 0)) {
        return(NA)
    }
    materias <- xml_children(materias)
    m <- t(simplify2array(xml_attrs(materias), FALSE))
    m <- cbind(m, text = xml_text(materias))
    as.data.frame(m)
}
tidy_alertas <- function(alertas) {
    if (all(xml_length(alertas) == 0)) {
        return(NA)
    }
    alertas <- xml_children(alertas)
    m <- t(simplify2array(xml_attrs(alertas), FALSE))
    m <- cbind(m, text = xml_text(alertas))
    as.data.frame(m)
}

tidy_referencias <- function(referencias) {
    if (all(xml_length(referencias) == 0)) {
        return(NA)
    }
    child <- xml_children(referencias)
    len <- xml_length(child)
    l <- vector("list", length(len))
    anterior <- xml_find_all(child, "//anterior")
    posterior <- xml_find_all(child, "//posterior")
    anterior <- lapply(anterior, ref)
    posterior <- lapply(posterior, ref)
    l2 <- list(anterior, posterior)
    l[len != 0] <- l2[len != 0]
    l <- lapply(l, simp)
    names(l) <- xml_name(child)
    l
}


simp <- function(x) {
    if (!is.null(x)) {
        t(simplify2array(x))
    } else {
        NA
    }
}

# For every anteriores there is one palabra and one texto
ref <- function(x) {
    attrs <- xml_attrs(x)
    attrs <- c(attrs, unlist(xml_attrs(xml_children(x)), FALSE))
    names <- xml_name(xml_children(x))
    values <- xml_text(xml_children(x))
    names(values) <- names
    c(attrs, values)
}
