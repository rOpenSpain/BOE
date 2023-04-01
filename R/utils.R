is_logical <- function(x) {
    is.logical(x) && length(x) && !is.na(x)
}
