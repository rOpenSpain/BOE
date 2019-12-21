test_that("retreive_sumario works", {
    skip_if_offline()
    sumario <- retrieve_sumario(as.Date("2019-12-02", "%Y-%m-%d"))
    expect_s3_class(sumario, "data.frame")

    expect_error(
        expect_warning(
            retrieve_sumario(
                as.Date("2019-12-01", "%Y-%m-%d")),
            "Missing data."),
        "API did not return xml.")

})

test_that("url_publications works", {
    skip_if_offline()
    sumario <- retrieve_sumario(as.Date("2019-12-02", "%Y-%m-%d"))
    urls <- url_publications(sumario)
    expect_length(urls, nrow(sumario))
})