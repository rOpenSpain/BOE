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

test_that("check dates lex 1", {
    vcr::use_cassette("retreive_document_dates", {
        rd <- retrieve_document("BOE-A-2009-100")
    })
    expect_s3_class(rd$fecha_disposicion, "Date")
    expect_s3_class(rd$fecha_publicacion, "Date")
    expect_s3_class(rd$fecha_vigencia, "POSIXct")
    expect_s3_class(rd$fecha_derogacion, "POSIXct")
    expect_s3_class(rd$fecha_actualizacion, "POSIXct")
})

test_that("check dates lex 2", {
    vcr::use_cassette("retreive_document_dates2", {
        rd <- retrieve_document("BOE-A-2009-54")
    })
    expect_s3_class(rd$fecha_disposicion, "Date")
    expect_s3_class(rd$fecha_publicacion, "Date")
    expect_s3_class(rd$fecha_vigencia, "POSIXct")
    expect_s3_class(rd$fecha_derogacion, "POSIXct")
    expect_s3_class(rd$fecha_actualizacion, "POSIXct")
})

test_that("check dates ads", {
    vcr::use_cassette("retreive_document_dates3", {
        rd <- retrieve_document("BOE-B-2009-100")
    })
    expect_s3_class(rd$fecha_publicacion, "Date")
    expect_s3_class(rd$fecha_actualizacion, "POSIXct")
})

test_that("check dates match", {
    vcr::use_cassette("retreive_document_dates4", {
        ad <- retrieve_document("BOE-B-2009-100")
        lex <- retrieve_document("BOE-A-2009-100")
    })
    adi <- sapply(ad, is)
    lexi <- sapply(lex, is)
    names_i <- intersect(names(adi), names(lexi))
    expect_equal(adi[names_i], lexi[names_i])

    adf <- startsWith(names(ad), "fecha")
    lexf <- startsWith(names(lex), "fecha")

    expect_false(any(vapply(adi[adf], function(x){any(x == "character")}, logical(1L))))
    expect_false(any(vapply(lexi[lexf], function(x){any(x == "character")}, logical(1L))))
})


test_that("cve instead of date", {
    expect_error(retrieve_sumario("BORME-S-2022-1", journal = "BORME"),
                 "You seem to have provided a cve: use retrieve_docment()")
})

