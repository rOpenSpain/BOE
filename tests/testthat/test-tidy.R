test_that("tidy_sumario works", {
    skip_if_offline()
    id <- sumario_nbo(format(as.Date("2017/10/02", "%Y/%m/%d"), "%Y%m%d"))
    vcr::use_cassette("tidy_sumario", {
        sumario_file <- get_xml(query_xml(id))
    })
    m <- tidy_sumario(sumario_file)
    expect_s3_class(m, "data.frame")
    expect_equivalent(ncol(m), 11)
    expect_s3_class(m$date, "Date")
    expect_true(is.numeric(m$pages))
})
