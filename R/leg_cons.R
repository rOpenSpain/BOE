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
#' @examples
#' lex("inteligencia artificial", Sys.Date() - 365)
lex <- function(query, from, to = Sys.Date(), offset = NULL, limit = -1) {
  check_date(from)
  check_date(to)
  check_limit(limit)
  check_offset(offset)
  req <- req_api(query = query,
                 from = format_date(from),
                 to = format_date(to),
                 offset = offset,
                 limit = limit)  |>
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
  req_id <- req_api()  |>
      req_url_path_append(leg_cons, "id") |>
      req_url_path_append(id)

  if (is_logical(metadatos) && isTRUE(metadatos)) {
      req_metadata <- req_api()  |>
          req_url_path_append(leg_cons, "id") |>
          req_url_path_append(id, "metadatadatos")
  }
  if (is_logical(analisis) && isTRUE(analisis)) {
      req_analisis <- req_api()  |>
          req_url_path_append(leg_cons, "id") |>
          req_url_path_append(id, "analisis")
  }
  if (is_logical(ELI) && isTRUE(ELI)) {
      req_ELI <- req_api()  |>
          req_url_path_append(leg_cons, "id") |>
          req_url_path_append(id, "metadata-eli")
  }

}

lex_text <- function(id) {
      req_ELI <- req_api()  |>
          req_url_path_append(leg_cons, "id") |>
          req_url_path_append(id, "metadata-eli")

}

sumario_boe <- function(fecha) {
    check_date(fecha)
    req_api() |>
        req_url_path_append("boe", "sumario", fecha)
}

sumario_borme <- function(fecha) {
    check_date(fecha)
    req_api() |>
        req_url_path_append("borme", "sumario", fecha)
}
