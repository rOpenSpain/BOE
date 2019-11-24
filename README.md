
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

The goal of BOE is to provide tools to retrieve data from BOE.

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

## Examples

This is a basic example which shows you how to solve find the
identifiers of some elements. The most important data is the sumario
(summary) which can be retrieved by the date:

``` r
library("BOE")
today <- Sys.Date()-1
sumario_hoy <- retrieve_sumario(today)
head(sumario_hoy)
#>         date sumario_nbo   sumario_code section             section_number
#> 1 2019-11-23         282 BOE-S-2019-282       1 I. Disposiciones generales
#> 2 2019-11-23         282 BOE-S-2019-282       1 I. Disposiciones generales
#> 3 2019-11-23         282 BOE-S-2019-282       1 I. Disposiciones generales
#> 4 2019-11-23         282 BOE-S-2019-282       1 I. Disposiciones generales
#> 5 2019-11-23         282 BOE-S-2019-282       1 I. Disposiciones generales
#> 6 2019-11-23         282 BOE-S-2019-282       1 I. Disposiciones generales
#>                       departament departament_etq         epigraph
#> 1             JEFATURA DEL ESTADO            7723 Medidas urgentes
#> 2          MINISTERIO DE HACIENDA            5140  Tabaco. Precios
#> 3 MINISTERIO DE CULTURA Y DEPORTE            9570     Subvenciones
#> 4 MINISTERIO DE CULTURA Y DEPORTE            9570     Subvenciones
#> 5 MINISTERIO DE CULTURA Y DEPORTE            9570     Subvenciones
#> 6 MINISTERIO DE CULTURA Y DEPORTE            9570     Subvenciones
#>                                                                                                                                                                                                                                                                              text
#> 1 Real Decreto-ley 17/2019, de 22 de noviembre, por el que se adoptan medidas urgentes para la necesaria adaptación de parámetros retributivos que afectan al sistema eléctrico y por el que se da respuesta al proceso de cese de actividad de centrales térmicas de generación.
#> 2                       Resolución de 22 de noviembre de 2019, de la Presidencia del Comisionado para el Mercado de Tabacos, por la que se publican los precios de venta al público de determinadas labores de tabaco en Expendedurías de Tabaco y Timbre del Área del Monopolio.
#> 3                                                             Real Decreto 673/2019, de 22 de noviembre, por el que se regula la concesión directa de subvenciones a determinadas entidades para la realización de actividades relacionadas con la cinematografía en el año 2019.
#> 4                                                                Real Decreto 674/2019, de 22 de noviembre, por el que se regula la concesión directa de determinadas subvenciones para la promoción internacional del sector del libro y el desarrollo del sector bibliotecario.
#> 5                                                                    Real Decreto 675/2019, de 22 de noviembre, por el que se regula la concesión directa de una subvención a la Real Academia de Bellas Artes de San Fernando para el desarrollo de sus actividades museísticas.
#> 6                                                                             Real Decreto 676/2019, de 22 de noviembre, por el que se regula la concesión directa de subvenciones a determinadas entidades para su funcionamiento y el desarrollo de sus actividades culturales.
#>        publication pages
#> 1 BOE-A-2019-16862     8
#> 2 BOE-A-2019-16863     2
#> 3 BOE-A-2019-16864     8
#> 4 BOE-A-2019-16865     8
#> 5 BOE-A-2019-16866     6
#> 6 BOE-A-2019-16867     6
```

If we are interested on a publication we can obtain the url of the
publication with:

``` r
# Say we are interested on the first result:
pdfs <- url_publications(sumario_hoy[1, ])
pdf # And we can download it with download.file(pdf)
#> function (file = if (onefile) "Rplots.pdf" else "Rplot%03d.pdf", 
#>     width, height, onefile, family, title, fonts, version, paper, 
#>     encoding, bg, fg, pointsize, pagecentre, colormodel, useDingbats, 
#>     useKerning, fillOddEven, compress) 
#> {
#>     initPSandPDFfonts()
#>     new <- list()
#>     if (!missing(width)) 
#>         new$width <- width
#>     if (!missing(height)) 
#>         new$height <- height
#>     if (!missing(onefile)) 
#>         new$onefile <- onefile
#>     if (!missing(title)) 
#>         new$title <- title
#>     if (!missing(fonts)) 
#>         new$fonts <- fonts
#>     if (!missing(version)) 
#>         new$version <- version
#>     if (!missing(paper)) 
#>         new$paper <- paper
#>     if (!missing(encoding)) 
#>         new$encoding <- encoding
#>     if (!missing(bg)) 
#>         new$bg <- bg
#>     if (!missing(fg)) 
#>         new$fg <- fg
#>     if (!missing(pointsize)) 
#>         new$pointsize <- pointsize
#>     if (!missing(pagecentre)) 
#>         new$pagecentre <- pagecentre
#>     if (!missing(colormodel)) 
#>         new$colormodel <- colormodel
#>     if (!missing(useDingbats)) 
#>         new$useDingbats <- useDingbats
#>     if (!missing(useKerning)) 
#>         new$useKerning <- useKerning
#>     if (!missing(fillOddEven)) 
#>         new$fillOddEven <- fillOddEven
#>     if (!missing(compress)) 
#>         new$compress <- compress
#>     old <- check.options(new, name.opt = ".PDF.Options", envir = .PSenv)
#>     if (!missing(family) && (inherits(family, "Type1Font") || 
#>         inherits(family, "CIDFont"))) {
#>         enc <- family$encoding
#>         if (inherits(family, "Type1Font") && !is.null(enc) && 
#>             enc != "default" && (is.null(old$encoding) || old$encoding == 
#>             "default")) 
#>             old$encoding <- enc
#>         family <- family$metrics
#>     }
#>     if (is.null(old$encoding) || old$encoding == "default") 
#>         old$encoding <- guessEncoding()
#>     if (!missing(family)) {
#>         if (length(family) == 4L) {
#>             family <- c(family, "Symbol.afm")
#>         }
#>         else if (length(family) == 5L) {
#>         }
#>         else if (length(family) == 1L) {
#>             pf <- pdfFonts(family)[[1L]]
#>             if (is.null(pf)) 
#>                 stop(gettextf("unknown family '%s'", family), 
#>                   domain = NA)
#>             matchFont(pf, old$encoding)
#>         }
#>         else stop("invalid 'family' argument")
#>         old$family <- family
#>     }
#>     version <- old$version
#>     versions <- c("1.1", "1.2", "1.3", "1.4", "1.5", "1.6", "1.7", 
#>         "2.0")
#>     if (version %in% versions) 
#>         version <- as.integer(strsplit(version, "[.]")[[1L]])
#>     else stop("invalid PDF version")
#>     onefile <- old$onefile
#>     if (!checkIntFormat(file)) 
#>         stop(gettextf("invalid 'file' argument '%s'", file), 
#>             domain = NA)
#>     .External(C_PDF, file, old$paper, old$family, old$encoding, 
#>         old$bg, old$fg, old$width, old$height, old$pointsize, 
#>         onefile, old$pagecentre, old$title, old$fonts, version[1L], 
#>         version[2L], old$colormodel, old$useDingbats, old$useKerning, 
#>         old$fillOddEven, old$compress)
#>     invisible()
#> }
#> <bytecode: 0x55dbce8574e0>
#> <environment: namespace:grDevices>
```

We can open the publication from R with:

``` r
open_publications(pdfs)
```

If we need to know the BOE code of a publication we can do so with:

``` r
sumario_xml(as.Date("2019/11/15"))
#> [1] "BOE-S-20191115"
# The codes of publication is the year and the number of said publication
sumario_nbo("2017", "275") 
#> [1] "BOE-S-2017-275"
anuncio("2012", "32498") 
#> [1] "BOE-B-2012-32498"
disposicion("2012", "32498")
#> [1] "BOE-A-2012-32498"
```

## Code of Conduct

Please note that the BOE project is released with a [Contributor Code of
Conduct](https://contributor-covenat.org/version/1/0/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
