test_that("check_date works", {
    expect_true(check_date(20110101))
    expect_error(check_date(20111301), "month")
    expect_true(check_date("20110101"))
    expect_error(check_date("20111301"),  "month")
    expect_true(check_date(as.Date("20110101", format = "%Y%m%d")))
})
