test_that("sumario_nbo works", {
    s <- sumario_nbo(format(as.Date("2009/01/01", "%Y/%m/%d"), "%Y%m%d"))
    expect_equal(s, "BOE-S-20090101")
})

test_that("sumario_cve works", {
    s <- sumario_cve(2019, 242)
    expect_equal(s, "BOE-S-2019-242")
    s <- sumario_cve("2019", "242")
    expect_equal(s, "BOE-S-2019-242")
})

test_that("elemento works", {
    s <- elemento(item = "B", year = 242, number = 242)
    expect_equal(s, "BOE-B-242-242")
    s <- elemento(item = "A", year = 242, number = 242)
    expect_equal(s, "BOE-A-242-242")
})


test_that("disposicion_cve works", {
    s <- disposicion_cve(year = 242, number = 242)
    expect_equal(s, "BOE-A-242-242")
})

test_that("anuncio_cve works", {
    s <- anuncio_cve(year = 242, number = 242)
    expect_equal(s, "BOE-B-242-242")
})


test_that("PDF code is valid", {
  expect_true(check_code("BOE-S-2014-242"))
  # Not sure about this there should be at most 366 summaries (one for each day)
  expect_true(check_code("BOE-A-2009-1"))
  expect_true(check_code("BOE-B-2009-1"))
  expect_true(check_code("BORME-C-2020-6153"))
  expect_true(check_code("BOE-S-2009-1"))
  expect_true(check_code("BOE-S-20141221"))
  expect_true(check_code("BOE-S-2014-2420"))
  expect_error(check_code("BOE-C-2009-1"))
  expect_error(check_code("BOE-S-2014"))
  expect_error(check_code(c("BOE-A-2009-1", "BOE-A-2009-1")))
})


test_that("sumario_cve works", {
  expect_equal(sumario_cve(2019, 242), "BOE-S-2019-242")
  # There shouldn't be summaries/sumarios more than one each day.
  expect_error(sumario_cve(2019, 2424))
  expect_error(sumario_cve(2019, -1), "numeric format")
  expect_equal(sumario_cve(1999, 1), "BOE-S-1999-1")
})
