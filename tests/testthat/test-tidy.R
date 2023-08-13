test_that("tidy_sumario works", {
    skip_if_offline()
    id <- sumario_nbo(format(as.Date("2017/10/02", "%Y/%m/%d"), "%Y%m%d"))
    vcr::use_cassette("tidy_sumario", {
        sumario_file <- get_xml(query_xml(id))
    })
    m <- tidy_sumario(sumario_file)
    expect_s3_class(m, "data.frame")
    expect_identical(ncol(m), 11L)
    expect_s3_class(m$date, "Date")
    expect_true(is.numeric(m$pages))
})

test_that("tidy_sumario keeps columns", {
    rd <- retrieve_document("BOE-S-20041029")
    expect_identical(ncol(rd), 11L)
    expect_identical(nrow(rd), 219L)
})

test_that("tidy_sumario works without warnings", {
    # This tests for "old" cases before 2009
    expect_no_warning(rd <- retrieve_document("BOE-S-2005-60"))
    expect_no_warning(rd1 <- retrieve_document("BOE-S-2009-60"))
    expect_identical(ncol(rd), ncol(rd1))
    expect_identical(ncol(rd), 11L)
    expect_identical(nrow(rd), 202L)
    expect_identical(nrow(rd1), 231L)

})
