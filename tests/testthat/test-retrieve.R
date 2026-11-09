test_that("retrieve_sumario works", {
  vcr::local_cassette("retrieve_sumario")

  sumario <- retrieve_sumario(as.Date("2019-12-02", "%Y-%m-%d"))
  expect_s3_class(sumario, "data.frame")

  expect_error(
    retrieve_sumario(
      as.Date("2019-12-01", "%Y-%m-%d")
    ),
    "La información solicitada no existe"
  )
})

test_that("url_publications works", {
  vcr::local_cassette("retrieve_sumario2")
  sumario <- retrieve_sumario(as.Date("2019-12-02", "%Y-%m-%d"))

  urls <- url_publications(sumario)
  expect_length(urls, nrow(sumario))
})

test_that("Two summaries works", {
  skip_if_offline()
  skip_on_cran()
  expect_warning(retrieve_sumario(structure(18337, class = "Date")), "More than one")
})


test_that("retrieve_docment A", {
  vcr::local_cassette("retrieve_document_a")
  sumario <- retrieve_document("BOE-A-2017-5")
  expect_s3_class(sumario, "data.frame")
})

test_that("retrieve_docment B", {
  vcr::local_cassette("retrieve_document_b")
  sumario <- retrieve_document("BOE-B-2017-5")
  expect_s3_class(sumario, "data.frame")
})

test_that("retrieve_docment S", {
  vcr::local_cassette("retrieve_document_s")
  expect_error(retrieve_document("BOE-S-2017-5"), "No longer supported")
})

test_that("retrieve_docment BORME", {
  vcr::local_cassette("retrieve_document_borme")
  expect_error(retrieve_document("BORME-S-2017-5"), "No longer supported")
})

test_that("check dates lex 1", {
  vcr::local_cassette("retrieve_document_dates")
  rd <- retrieve_document("BOE-A-2009-100")
  expect_s3_class(rd$fecha_disposicion, "Date")
  expect_s3_class(rd$fecha_publicacion, "Date")
  expect_s3_class(rd$fecha_vigencia, "POSIXct")
  expect_s3_class(rd$fecha_derogacion, "POSIXct")
  expect_s3_class(rd$fecha_actualizacion, "POSIXct")
})

test_that("check dates lex 2", {
  vcr::local_cassette("retrieve_document_dates2")
  rd <- retrieve_document("BOE-A-2009-54")
  expect_s3_class(rd$fecha_disposicion, "Date")
  expect_s3_class(rd$fecha_publicacion, "Date")
  expect_s3_class(rd$fecha_vigencia, "POSIXct")
  expect_s3_class(rd$fecha_derogacion, "POSIXct")
  expect_s3_class(rd$fecha_actualizacion, "POSIXct")
})

test_that("check dates ads", {
  vcr::local_cassette("retrieve_document_dates3")
  rd <- retrieve_document("BOE-B-2009-100")
  expect_s3_class(rd$fecha_publicacion, "Date")
  expect_s3_class(rd$fecha_actualizacion, "POSIXct")
})

test_that("check dates match", {
  vcr::local_cassette("retrieve_document_dates4")
  ad <- retrieve_document("BOE-B-2009-100")
  lex <- retrieve_document("BOE-A-2009-100")
  adi <- sapply(ad, is)
  lexi <- sapply(lex, is)
  names_i <- intersect(names(adi), names(lexi))
  expect_equal(adi[names_i], lexi[names_i])

  adf <- startsWith(names(ad), "fecha")
  lexf <- startsWith(names(lex), "fecha")

  expect_false(any(vapply(adi[adf], function(x) {
    any(x == "character")
  }, logical(1L))))
  expect_false(any(vapply(lexi[lexf], function(x) {
    any(x == "character")
  }, logical(1L))))
})


test_that("cve instead of date", {
  expect_error(
    retrieve_sumario("BORME-S-2022-1", journal = "BORME"),
    "You seem to have provided a cve: use retrieve_docment()"
  )
})

