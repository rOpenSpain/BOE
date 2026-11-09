BASE_URL <- "https://boe.es/"
JOURNAL_URL <- c(BORME = "diario_borme", BOE = "diario_boe")


#' Build a query for an XML
#'
#' @param id The id of the xml document you want.
#' @return A query for the xml.
#' @seealso [sumario_nbo()]
#' @export
#' @examples
#' id <- sumario_nbo(format(as.Date("2017/10/02", "%Y/%m/%d"), "%Y%m%d"))
#' cve <- sumario_cve("2017", "237") # Same document but by the CVE
#' query_xml(id)
#' query_xml(cve)
query_xml <- function(id) {
  check_code(id)
  force(BASE_URL)
  force(JOURNAL_URL)

  journal <- strsplit(id, split = "-", fixed = TRUE)[[1]][1]
  journal <- match.arg(journal, c("BOE", "BORME"))
  paste0(BASE_URL,
         paste0(JOURNAL_URL[journal], "/xml.php"),
         paste0("?id=", id)
  )
}


query_xml_sumario <- function(id, journal = "BOE") {
  force(BASE_URL)
  force(JOURNAL_URL)

  # On 2024-10-08
  # https://boe.es/datosabiertos/api/boe/sumario/20250125
  journal <- match.arg(journal, c("BOE", "BORME"))
  path <- paste0("datosabiertos/api/", tolower(journal), "/sumario/", id)
  paste0(BASE_URL, path = path)
}

#' Build a query for the webpage
#'
#' @param cve The CVE of the document you want.
#' @return  A query url.
#' @seealso query_consolidada
#' @export
#' @examples
#' cve <- sumario_cve("2017", "117")
#' query_htm(cve)
query_htm <- function(cve) {
  check_code(cve)
  force(BASE_URL)
  force(JOURNAL_URL)
  journal <- strsplit(cve, "-", fixed = TRUE)[[1]][1]
  paste0(BASE_URL,
    paste0(JOURNAL_URL[journal], "/text.php"),
    paste0("?id=", cve)
  )
}

#' Build a query for the webpage
#'
#' Look for the consolidated law online
#' @param cve The CVE of the document you want.
#' @return  A query url.
#' @export
#' @examples
#' cve <- disposicion_cve("2017", "117")
#' query_consolidada(cve)
query_consolidada <- function(cve) {
  check_code(cve)
  force(BASE_URL)
  ids <- strsplit(cve, "-", fixed = TRUE)[[1]]
  if (ids[2] != "A") {
    stop("Documents with BOE-A-*", call. = FALSE)
  }

  if (ids[1] != "BOE") {
    stop("This is only for laws on the BOE.", call. = FALSE)
  }
  paste0(BASE_URL,
    "buscar/act.php",
    paste0("?id=", cve)
  )
}

#' Query a pdf from the BOE
#'
#' To query a pdf you must know the number of the piece you are looking for and
#' the date it was published.
#' @param year Character of the number of the year: YYYY
#' @param month Character of the number of the month: MM.
#' @param day Character of the number of the day: DD.
#' @param code Code of the publication to query.
#' @return A link to the pdf.
#' @export
#' @examples
#' cve <- sumario_cve("2017", "237")
#' query_pdf("2017", "10", "02", cve)
query_pdf <- function(year, month, day, code) {
  vapply(code, check_code, logical(1))
  force(BASE_URL)
  journal <- tolower(gsub("-.*", "", code))
  p <- paste(journal, "dias", year, month, day, "pdfs", paste0(code, ".pdf"), sep = "/")
  paste0(BASE_URL, path = p)
}

#' Retrieve the XML content
#'
#' Look up on the internet and get the content
#' @param query A query to BOE.
#' @seealso [query_xml()]
#' @export
#' @examples
#' id <- disposicion_cve("2017", "117")
#' url <- query_xml(id)
#' \donttest{
#' get_xml(url)
#' }
get_xml <- function(query) {
  if (grepl("BO(RM)?E-S-", query)) {
    stop("No longer supported")
  }
  req <- request(query) |>
    req_user_agent("BOE (https://ropenspain.github.io/BOE)") |>
    req_throttle(capacity = 30, fill_time_s = 60) |>
    req_retry(max_tries = 5, backoff = function(x) {
      x
    })
  req_perform(req) |> resp_body_xml()
}
