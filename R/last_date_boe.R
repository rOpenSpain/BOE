#' Last day of BOE
#'
#' Returns the date of the last BOE under normal circumstances.
#' @return A date.
#' @export
#' @examples
#' last_date_boe()
last_date_boe <- function() {
    today <- Sys.Date()
    time <- as.numeric(format(Sys.time(), format = "%H%I", tz = "Europe/Madrid"))
    # On Sunday there is not BOE unless there is an extraordinary publication
    # Also it is published at 730 local time so we check for it
    if (format(today, "%u") == "7" || time < 730L) {
        today <- today - 1
    }
    today
}
