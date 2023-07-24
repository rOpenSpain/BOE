test_that("query_pdf works", {
    code <- sumario_cve("2017", "237")
    codes <- c(code, sumario_cve("2017", "238"))
    url <- query_pdf("2017", "10", "02", code)
    expect_identical(url,
                 "https://boe.es/boe/dias/2017/10/02/pdfs/BOE-S-2017-237.pdf")
    expect_true(endsWith(url, ".pdf"))

    urls <- query_pdf("2017", "10", "02", codes)
    expect_length(urls, 2L)
})


test_that("query_htm works", {
    code <- sumario_cve("2017", "237")
    url <- query_htm(code)
    expect_identical(url,
                 "https://boe.es/diario_boe/text.php?id=BOE-S-2017-237")
    expect_true(endsWith(url, code))
})

test_that("get_xml works" , {
    skip_if_offline()
    id <- sumario_nbo(format(as.Date("2017/10/02", "%Y/%m/%d"), "%Y%m%d"))
    vcr::use_cassette("get_xml", {
        xml <- get_xml(query_xml(id))
    })
    expect_s3_class(xml, "xml_document")
})

test_that("query_consolidada works", {
    skip_if_offline()
    cve <- disposicion_cve("2017", "117")
    q <- query_consolidada(cve)
    expect_true(endsWith(q, cve))
    expect_true(startsWith(q, "https://boe.es/buscar/act.php?id="))
})
