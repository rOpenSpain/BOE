

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
