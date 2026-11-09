leg_cons <- "legislacion-consolidada"

#' Search consolidated legislature.
#'
#' @param query Search parameters.
#' @param from Earliest date from which the legislation is collected.
#' @param to Latest date from which the legislation is collected.
#' @param offset Return from this results.
#' @param limit How many results return. The default returns all of them.
#'
#' @importFrom httr2 req_url_path_append
#' @importFrom httr2 req_perform_iterative
#' @importFrom httr2 resp_body_xml
#' @importFrom httr2 resp_url_query
#' @importFrom httr2 req_perform
#' @export
#' @examples
#' lex("inteligencia artificial", Sys.Date() - 365)
lex <- function(query, from, to = Sys.Date(), offset = NULL, limit = -1) {
  check_date(from)
  check_date(to)
  check_limit(limit)
  check_offset(offset)
  req <- req_api(
    query = query,
    from = format_date(from),
    to = format_date(to),
    offset = offset,
    limit = limit
  ) |>
    req_url_path_append(leg_cons)

  rr <- req_perform_iterative(req, function(resp, req) {
    length <- resp |>
      resp_body_xml() |>
      xml2::xml_child("/data") |>
      xml_length()
    if (length <= 1000L) {
      return(NULL)
    }
    previous_length <- resp_url_query(resp, "offset", default = 0L)

    req_url_query(req, offset = length + as.numeric(previous_length))
  })
  # resp <- req |>
  #   req_perform() |>
  #   resp_body_xml()
}


#' Download by CVE
#'
#' @param id CVE of the document.
#' @param metadatos Logical value if metadata should be retrieved.
#' @param analisis Logical value if analysis should be retrieved.
#' @param ELI Logical value if ELI metadata should be retrieved.
#'
#' @returns Something
#'
#' @export
#'
#' @examples
#' lex_id("BOE-A-2000-17579")
lex_id <- function(id, metadatos = FALSE, analisis = FALSE, ELI = FALSE) {
  xsd <- "https://www.boe.es/datosabiertos/definitions/download_schema.php?id=legislacion-consolidada-by-id"
  req_id <- req_api() |>
    req_url_path_append(leg_cons, "id") |>
    req_url_path_append(id)

  if (is_logical(metadatos) && isTRUE(metadatos)) {
    req_metadata <- req_api() |>
      req_url_path_append(leg_cons, "id") |>
      req_url_path_append(id, "metadatadatos")
  }
  if (is_logical(analisis) && isTRUE(analisis)) {
    req_analisis <- req_api() |>
      req_url_path_append(leg_cons, "id") |>
      req_url_path_append(id, "analisis")
  }
  if (is_logical(ELI) && isTRUE(ELI)) {
    req_ELI <- req_api() |>
      req_url_path_append(leg_cons, "id") |>
      req_url_path_append(id, "metadata-eli")
  }
}

lex_text <- function(id) {
  req_ELI <- req_api() |>
    req_url_path_append(leg_cons, "id") |>
    req_url_path_append(id, "metadata-eli")
}

#' @importFrom httr2 req_template
#' @importFrom xml2 xml_find_first
sumario_boe <- function(fecha) {
  check_date(fecha)
  fecha <- format_date(fecha)
  xml <- req_api() |>
    req_template("boe/sumario/{fecha}") |>
    req_perform() |>
    resp_body_xml()

  # Item is the base
  items <- xml_find_all(xml, "//item")
  item <- xml_find_all(items, "identificador|titulo")
  m_item <- matrix(xml_text(item), ncol = 2, byrow = TRUE)
  colnames(m_item) <- c("publication", "text")


  pdfs <- items |> xml_find_all("url_pdf")
  pdf_sizes <- do.call(rbind, xml_attrs(pdfs))
  pdf_sizes <- apply(pdf_sizes, 1:2, as.numeric)
  pdf_sizes2 <- cbind(pdf_sizes, pages = abs(pdf_sizes[, 4] - pdf_sizes[, 3]) +1)

  # There is a differences where some BOE-B have epigrahps and others don't
  # xml_parents(items[[length(items)]]) |> xml_name() |> cat(sep = ">")
  #          departamento>seccion>diario>sumario>data>response
  # xml_parents(items[[1]]) |> xml_name() |> cat(sep = ">")
  # epigrafe>departamento>seccion>diario>sumario>data>response
  parent_item <- xml_parent(items)
  type_pi <- xml_name(parent_item)
  l_parent_item <- xml_length(parent_item)

  # Expand epigraph
  w_epi <- which(type_pi == "epigrafe")
  w_dept <- which(type_pi == "departamento")
  m_epigrafe <- attrs2matrix(parent_item[w_epi])
  m_extra <- matrix(nrow = sum(l_parent_item[w_dept]))
  m_epigrafe <- rbind(m_epigrafe, m_extra)
  colnames(m_epigrafe) <- "epigraph"

  # Expand department that are for epigraph
  departaments <- xml_find_all(xml, "//departamento")
  m_departaments <- attrs2matrix(departaments)
  rows <- rep(1, each = nrow(m_departaments))
  times_rows <- rows
  times_rows[w_epi] <- l_parent_item[w_epi]
  r_epigraph <- rep(seq_along(rows), times = times_rows)
  m_departaments <- m_departaments[r_epigraph, , drop = FALSE]
  colnames(m_departaments) <- c("departament_etq", "departament")

  seccion <- xml |> xml_find_all("//seccion")
  m_seccion <- attrs2matrix(seccion)
  r_seccion_by_dept <- rep(seq_len(nrow(m_seccion)), times = xml_length(departaments))
  m_seccion <- m_seccion[r_seccion_by_dept, , drop = FALSE][r_epigraph, , drop = FALSE]
  colnames(m_seccion) <- c("section", "section_number")

  info <- cbind(m_seccion,
                m_departaments,
                m_epigrafe,
                m_item,
                pdf_sizes2[, "pages", drop = FALSE])
  sumario_nbo <- xml_find_all(xml, "//sumario/diario") |> xml_attrs() |> unlist(FALSE, FALSE)
  sumario_code <- xml_find_first(xml, "//sumario_diario/identificador") |> xml_text()

  if (!endsWith(sumario_code, sumario_nbo[[1]])) {
    warning("Code doesn't match", immediate. = TRUE)
  }
  if (length(sumario_nbo) > 1) {
    warning("More than one summary, using the latest id", immediate. = TRUE)
  }

  out <- cbind.data.frame(date =  as.Date(fecha, "%Y%m%d"),
               sumario_nbo = sumario_nbo[[1]],
               sumario_code = sumario_code,
               info)
  out$pages <- as.numeric(out$pages)
  out
}

sumario_borme <- function(fecha) {
  check_date(fecha)
  fecha <- format_date(fecha)
  req_template(req_api(), "borme/sumario/{fecha}")
}
