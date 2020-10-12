test_that("sumario_xml works", {
    s <- sumario_xml(format(as.Date("2009/01/01", "%Y/%m/%d"), "%Y%m%d"))
    expect_equal(s, "BOE-S-20090101")
})

test_that("sumario_nbo works", {
    s <- sumario_nbo(2019, 242)
    expect_equal(s, "BOE-S-2019-242")
})

test_that("elemento works", {
    s <- elemento(item = "B", year = 242, number = 242)
    expect_equal(s, "BOE-B-242-242")
    s <- elemento(item = "A", year = 242, number = 242)
    expect_equal(s, "BOE-A-242-242")
})


test_that("disposicion works", {
    s <- disposicion(year = 242, number = 242)
    expect_equal(s, "BOE-A-242-242")
})

test_that("anuncio works", {
    s <- anuncio(year = 242, number = 242)
    expect_equal(s, "BOE-B-242-242")
})


test_that("PDF code is valid", {
  expect_true(check_code("BOE-S-2014-242"))
  # Not sure about this there should be at most 366 summaries (one for each day)
  expect_true(check_code("BOE-A-2009-1"))
  expect_true(check_code("BOE-B-2009-1"))
  expect_true(check_code("BOE-S-2009-1"))
  expect_error(check_code("BOE-C-2009-1"))
  expect_true(check_code("BOE-S-2014-2420"))
  expect_error(check_code("BOE-S-2014"))
  expect_error(check_code("BOE-S-2008-1"))
  expect_error(check_code("BOE-S-20141221"))
})


test_that("sumario_nbo works", {
  sumario_nbo(2019, 242)
  expect_error(sumario_nbo(2019, 2424), "numeric format")
  expect_error(sumario_nbo(2019, -1), "numeric format")
  expect_error(sumario_nbo(1999, 1), "starting from 2009")
})
