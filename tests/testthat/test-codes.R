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
  # expect_true("BOE-S-2014-242")
  # expect_false("BOE-S-0014-242")
  # expect_false("BOE-S-2014")
  # expect_false("BOE-S-20141221")
})
