is_logical <- function(x) {
  is.logical(x) && length(x) && !is.na(x)
}

check_date <- function(x) {
  if (is.numeric(x)) {
    x <- as.character(x)
  }

  if (!is.na(format_date(x))) {
    return(TRUE)
  }

  # For years without month and day
  if (nchar(x) == 4L && as.numeric(x) > 1) {
    return(TRUE)
  }

  y <- strsplit(x, "")[[1]]
  month <- as.numeric(paste0(y[5L:6L], collapse = ""))
  day <- as.numeric(paste0(y[7L:8L], collapse = ""))
  if (!is.na(month) && month >= 13 ) {
    stop("The month is greater than 12.", call. = FALSE)
  }
  if (!is.na(month) && day >= 31L) {
    stop("The day is greater than 31.", call. = FALSE)
  }
  out <- strptime(x, "%Y%m%d")
  if (anyNA(out)) {
    stop("That date does not exists, check the day of the month.",
         call. = FALSE
    )
  }
  FALSE
}

format_dates <- function(x) {
  fechas_metadatos <- startsWith(colnames(x), "fecha_")
  x[fechas_metadatos] <- lapply(x[fechas_metadatos],
                                as.POSIXct,
                                format = "%Y%m%d%H%M%S",
                                tz = "CET"
  )
  if (!is.null(x$fecha_disposicion)) {
    x$fecha_disposicion <- as.Date(x$fecha_disposicion)
  }
  if (!is.null(x$fecha_publicacion)) {
    x$fecha_publicacion <- as.Date(x$fecha_publicacion)
  }
  x
}

format_date <- function(date) {
  if (is(date, "Date")) {
    format(date, "%Y%m%d")
  } else if (is.numeric(date)) {
    as.character(date)
  } else if (is.character(date)) {
    format(
      as.Date(date,
              tryFormats = c("%Y%m%d", "%Y-%m-%d", "%Y/%m/%d"),
              optional = TRUE
      ),
      "%Y%m%d"
    )
  }
}

check_limit <- function(limit) {
  if (!is.numeric(limit)) {
    stop("Limit must be a numeric number from -1 to higher numbers", call. = FALSE)
  }
  if (limit < -1L) {
    stop("Limit can only be between [-1, Inf]", call. = FALSE)
  }
}

check_offset <- function(offset) {
  if (!is.numeric(offset)) {
    stop("Offset must be a numeric number higher than 1.", call. = FALSE)
  }
  if (offset <= 0L) {
    stop("Offset must be a postivie number", call. = FALSE)
  }
}
