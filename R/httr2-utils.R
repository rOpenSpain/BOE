#' @importFrom httr2 request
#' @importFrom httr2 req_headers
#' @importFrom httr2 req_user_agent
#' @importFrom httr2 req_url_query
#' @importFrom httr2 req_throttle
#' @importFrom httr2 req_retry
req_api <- function(params) {
  request("https://boe.es/datosabiertos/api/") |> 
    req_headers("Accept" = "application/xml") |>
    req_user_agent("BOE (https://ropenspain.github.io/BOE)") |> 
    req_url_query(!!!params) |>
    req_throttle(capacity = 30) |> 
    req_retry(max_tries = 5, backoff = function(x) { x })
}
