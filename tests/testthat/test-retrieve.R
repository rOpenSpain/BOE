test_that("retreive_sumario works", {
    vcr::use_cassette("retreive_sumario", {
        sumario <- retrieve_sumario(as.Date("2019-12-02", "%Y-%m-%d"))
    })
    expect_s3_class(sumario, "data.frame")

    expect_error(
        expect_warning(
            retrieve_sumario(
                as.Date("2019-12-01", "%Y-%m-%d")),
            "Missing data."),
        "API did not find the requested document.")

})

test_that("url_publications works", {
    vcr::use_cassette("retreive_sumario2", {
        sumario <- retrieve_sumario(as.Date("2019-12-02", "%Y-%m-%d"))
    })
    urls <- url_publications(sumario)
    expect_length(urls, nrow(sumario))
})

test_that("Two summaries works", {
    skip_if_offline()
    skip_on_cran()
    expect_warning(retrieve_sumario(structure(18337, class = "Date")), NA)
})


test_that("retrieve_docment A", {
    vcr::use_cassette("retreive_document_a", {
        sumario <- retrieve_document("BOE-A-2017-5")
    })
    expect_s3_class(sumario, "data.frame")
})
test_that("retrieve_docment B", {
    vcr::use_cassette("retreive_document_b", {
        sumario <- retrieve_document("BOE-B-2017-5")
    })
    expect_s3_class(sumario, "data.frame")
})
test_that("retrieve_docment S", {
    vcr::use_cassette("retreive_document_s", {
        sumario <- retrieve_document("BOE-S-2017-5")
    })
    expect_s3_class(sumario, "data.frame")
})
test_that("retrieve_docment BORME", {
    vcr::use_cassette("retreive_document_borme", {
        sumario <- retrieve_document("BORME-S-2017-5")
    })
    expect_s3_class(sumario, "data.frame")
})
