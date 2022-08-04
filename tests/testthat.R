library(BOE)
library(testthat)
check_suggested <- requireNamespace("testthat", quietly = TRUE) &&
    requireNamespace("vcr", quietly = TRUE)
if (check_suggested) {
    test_check("BOE")
}
