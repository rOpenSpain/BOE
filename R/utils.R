is_logical <- function(x) {
    is.logical(x) && length(x) && !is.na(x)
}


format_dates <- function(x) {
    fechas_metadatos <- startsWith(colnames(x), "fecha_")
    x[fechas_metadatos] <- lapply(x[fechas_metadatos],
                                          as.POSIXct, format = "%Y%m%d%H%M%S",
                                          tz = "CET")
    if (!is.null(x$fecha_disposicion)) {
        x$fecha_disposicion <- as.Date(x$fecha_disposicion)
    }
    if (!is.null(x$fecha_publicacion)) {
        x$fecha_publicacion <- as.Date(x$fecha_publicacion)
    }
    x
}
