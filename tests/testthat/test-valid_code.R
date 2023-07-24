test_that("valid_code works", {
    expect_false(valid_code("BOE-S-2014"))
    expect_false(valid_code("BOE-S-2014"))
    expect_false(valid_code("BORME-S-2014"))
})
