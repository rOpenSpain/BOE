
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BOE

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/rOpenSpain/BOE.svg?branch=master)](https://travis-ci.org/rOpenSpain/BOE)
[![Codecov test
coverage](https://codecov.io/gh/rOpenSpain/BOE/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenSpain/BOE?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->

The goal of BOE is to provide tools to retrieve data from BOE either
from the **Boletín Oficial del Estado** or from the BORME **Boletín
Oficial del Registro Mercantil del Estado**.

## Installation

You can install the released version of BOE from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("BOE")
```

Or you can install it from github with:

``` r
devtools::install_github("rOpenSpain/BOE")
```

## Examples

This is a basic example which shows you how to solve find the
identifiers of some elements. The most important data is the sumario
(summary) which can be retrieved by the date:

``` r
library("BOE")
today <- Sys.Date()
sumario_hoy <- retrieve_sumario(today)
head(sumario_hoy)
#>         date sumario_nbo  sumario_code section             section_number
#> 1 2020-03-17          71 BOE-S-2020-71       1 I. Disposiciones generales
#> 2 2020-03-17          71 BOE-S-2020-71       1 I. Disposiciones generales
#> 3 2020-03-17          71 BOE-S-2020-71       1 I. Disposiciones generales
#> 4 2020-03-17          71 BOE-S-2020-71       1 I. Disposiciones generales
#> 5 2020-03-17          71 BOE-S-2020-71       1 I. Disposiciones generales
#> 6 2020-03-17          71 BOE-S-2020-71       1 I. Disposiciones generales
#>                      departament departament_etq
#> 1        TRIBUNAL CONSTITUCIONAL            1410
#> 2          MINISTERIO DE DEFENSA            6110
#> 3 COMUNIDAD AUTÓNOMA DE CATALUÑA            8070
#> 4 COMUNIDAD AUTÓNOMA DE CATALUÑA            8070
#> 5 COMUNIDAD AUTÓNOMA DE CATALUÑA            8070
#> 6     COMUNIDAD FORAL DE NAVARRA            8170
#>                                     epigraph
#> 1         Cuestiones de inconstitucionalidad
#> 2 Estado de alarma. Medidas crisis sanitaria
#> 3                        Sector vitivinícola
#> 4                                   Vivienda
#> 5                        Presupuestos. Aguas
#> 6                               Presupuestos
#>                                                                                                                                                                                                                                                                   text
#> 1                                                                                  Cuestión interna de inconstitucionalidad n.º 1231-2020, en relación con el último párrafo del artículo 238 bis LECrim., en la redacción dada por la Ley 13/2009, de 3 de noviembre.
#> 2                                            Instrucción de 16 de marzo de 2020, del Ministerio de Defensa, por la que se establecen medidas para la gestión de la situación de la crisis sanitaria ocasionada por el COVID-19 en el ámbito del Ministerio de Defensa.
#> 3                                                                                                                                                                                                                    Ley 2/2020, de 5 de marzo, de la vitivinicultura.
#> 4                                                                                                     Decreto-ley 1/2020, de 21 de enero, por el que se modifica el Decreto-ley 17/2019, de 23 de diciembre, de medidas urgentes para mejorar el acceso a la vivienda.
#> 5 Decreto-ley 2/2020, de 21 de enero, de necesidades financieras del sector público en prórroga presupuestaria y de modificación del texto refundido de la legislación en materia de aguas de Cataluña, aprobado por el Decreto legislativo 3/2003, de 4 de noviembre.
#> 6                                                                                                                                                                              Ley Foral 5/2020, de 4 de marzo, de Presupuestos Generales de Navarra para el año 2020.
#>       publication pages
#> 1 BOE-A-2020-3780     1
#> 2 BOE-A-2020-3781     1
#> 3 BOE-A-2020-3782    50
#> 4 BOE-A-2020-3783     2
#> 5 BOE-A-2020-3784     6
#> 6 BOE-A-2020-3785    49
```

If we are interested on a publication we can obtain the url of the
publication with:

``` r
# Say we are interested on the first result:
pdfs <- url_publications(sumario_hoy[1, ])
pdfs # And we can download it with download.file(pdfs)
#> [1] "https://boe.es/boe/dias/2020/03/17/pdfs/BOE-A-2020-3780.pdf"
```

We can open the publication from R with:

``` r
open_publications(pdfs)
```

If we need to know the BOE code of a publication we can do so with:

``` r
sumario_xml(as.Date("2019/11/15"))
#> [1] "BOE-S-20191115"
sumario_xml(as.Date("2019/11/15"), journal = "BORME")
#> [1] "BORME-S-20191115"
# The codes of publication is the year and the number of said publication
sumario_nbo("2017", "275") 
#> [1] "BOE-S-2017-275"
sumario_nbo("2017", "275", journal = "BORME") 
#> [1] "BORME-S-2017-275"
anuncio("2012", "32498") 
#> [1] "BOE-B-2012-32498"
disposicion("2012", "32498")
#> [1] "BOE-A-2012-32498"
```

## Code of Conduct

Please note that the BOE project is released with a [Contributor Code of
Conduct](https://contributor-covenat.org/version/1/0/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
