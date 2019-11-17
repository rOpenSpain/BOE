test_that("query_pdf works", {
    code <- sumario_nbo("2017", "237")
    url <- query_pdf("2017", "10", "02", code)
    expect_equal(url,
                 "https://boe.es/boe/dias/2017/10/02/pdfs/BOE-S-2017-237.pdf")
    expect_true(endsWith(url, ".pdf"))
})


test_that("get_xml works" , {
    id <- sumario_xml(format(as.Date("2017/10/02", "%Y/%m/%d"), "%Y%m%d"))
    xml <- get_xml(query_xml(id))
    expect_s3_class(xml, "xml_document")
})