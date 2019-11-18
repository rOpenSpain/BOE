
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BOE

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/llrs/BOE.svg?branch=master)](https://travis-ci.org/llrs/BOE)
[![Codecov test
coverage](https://codecov.io/gh/llrs/BOE/branch/master/graph/badge.svg)](https://codecov.io/gh/llrs/BOE?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of BOE is to provide tools to retrieve data from BOE

## Installation

You can install the released version of BOE from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("BOE")
```

Or you can install it from github with:

``` r
devtools::install_github("llrs/BOE")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library("BOE")
## basic example code
sumario_xml(as.Date("2019/11/15"))
#> [1] "BOE-S-20191115"
anuncio("2012", "32498")
#> [1] "BOE-A-2012-32498"
```

For instance you can download all the summaries available with:

``` r
library(BOE)
path = fs::dir_create("BOE_xml")
# available from 2009/01/01
s <- seq(from = as.Date("2019/10/01", "%Y/%m/%d"),
         to = Sys.Date(),
         by = 1)
done <- purrr::map(s, function(x){
    sumario <- sumario_xml(format(as.Date(x, "%Y/%m/%d"), "%Y%m%d"))
    xml2::download_xml(url = BOE::query_xml(sumario),
                       file = fs::path(path,
                                       glue::glue("{x}.xml")))
})
```


