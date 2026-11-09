#' @importFrom httr2 request
#' @importFrom httr2 req_headers
#' @importFrom httr2 req_user_agent
#' @importFrom httr2 req_url_query
#' @importFrom httr2 req_throttle
#' @importFrom httr2 req_retry
#' @importFrom httr2 req_error
req_api <- function(...) {
  force(BASE_URL)
  request(BASE_URL) |>
    req_headers("Accept" = "application/xml") |>
    req_user_agent("BOE (https://ropenspain.github.io/BOE)") |>
    req_url_path_append("datosabiertos/api/") |>
    req_url_query(...) |>
    req_throttle(capacity = 30, fill_time_s = 60) |>
    req_retry(max_tries = 5, backoff = function(x) {
      x
    }) |>
    req_error(body = function(resp) {
      resp |>
        resp_body_xml() |>
        xml_find_first("//text") |>
        xml_text()
    })
}
