
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BOE

<!-- badges: start -->

[![R-CMD-check](https://github.com/rOpenSpain/BOE/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rOpenSpain/BOE/actions/workflows/R-CMD-check.yaml)
[![Travis build
status](https://travis-ci.org/rOpenSpain/BOE.svg?branch=master)](https://travis-ci.org/rOpenSpain/BOE)
[![Codecov test
coverage](https://codecov.io/gh/rOpenSpain/BOE/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenSpain/BOE?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->

The goal of BOE is to provide tools to retrieve data from
[BOE](https://boe.es) either from the **Boletín Oficial del Estado** or
from the BORME **Boletín Oficial del Registro Mercantil del Estado**.

You can see examples of what is capable on the vignette and with more
data this [website](https://llrs.github.io/BOE_historico/).

## Installation

You can install it from github with:

``` r
remotes::install_github("rOpenSpain/BOE")
```

## Examples

This is a basic example which shows you how to solve find the
identifiers of some elements. The most important data is the *sumario*
(summary) which can be retrieved by the date:

``` r
library("BOE")
today <- Sys.Date()
sumario_hoy <- retrieve_sumario(today)
head(sumario_hoy)
#>         date sumario_nbo   sumario_code section             section_number
#> 1 2026-11-09         279 BOE-S-2026-279       1 I. Disposiciones generales
#> 2 2026-11-09         279 BOE-S-2026-279       1 I. Disposiciones generales
#> 3 2026-11-09         279 BOE-S-2026-279       1 I. Disposiciones generales
#> 4 2026-11-09         279 BOE-S-2026-279       1 I. Disposiciones generales
#> 5 2026-11-09         279 BOE-S-2026-279       1 I. Disposiciones generales
#> 6 2026-11-09         279 BOE-S-2026-279       1 I. Disposiciones generales
#>   departament_etq
#> 1            9585
#> 2            5140
#> 3            1430
#> 4            8060
#> 5            8060
#> 6            8060
#>                                                          departament
#> 1 MINISTERIO DE LA PRESIDENCIA, JUSTICIA Y RELACIONES CON LAS CORTES
#> 2                                             MINISTERIO DE HACIENDA
#> 3                                                   TRIBUNAL SUPREMO
#> 4                           COMUNIDAD AUTÓNOMA DE CASTILLA-LA MANCHA
#> 5                           COMUNIDAD AUTÓNOMA DE CASTILLA-LA MANCHA
#> 6                           COMUNIDAD AUTÓNOMA DE CASTILLA-LA MANCHA
#>                                epigraph      publication
#> 1    Ciudadanía española en el exterior BOE-A-2026-23384
#> 2 Gastos públicos. Cierre del ejercicio BOE-A-2026-23385
#> 3                            Sentencias BOE-A-2026-23386
#> 4 Medidas administrativas y tributarias BOE-A-2026-23387
#> 5                 Servicio farmacéutico BOE-A-2026-23388
#> 6               Consumidores y usuarios BOE-A-2026-23389
#>                                                                                                                                                                                                                                                                                                                                       text
#> 1                                                                                                                                                Real Decreto 954/2026, de 4 de noviembre, por el que se aprueba el Reglamento de desarrollo de la Ley 40/2006, de 14 de diciembre, del Estatuto de la ciudadanía española en el exterior.
#> 2                                                                                                                                                          Orden HAC/1184/2026, de 5 de noviembre, por la que se regulan las operaciones de cierre del ejercicio 2026 relativas al presupuesto de gastos y operaciones no presupuestarias.
#> 3 Sentencia de 8 de septiembre de 2026, de la Sala Tercera del Tribunal Supremo, que estima el recurso contencioso-administrativo interpuesto por la representación de Fundación Proa (Proactiva Open Arms), contra el Real Decreto 186/2023, de 21 de marzo, por el que se aprueba el Reglamento de Ordenación de la Navegación Marítima.
#> 4                                                                                                                                                                                                                                              Ley 1/2026, de 26 de marzo, de Medidas Administrativas y Tributarias de Castilla-La Mancha.
#> 5                                                                                                                                                                                          Ley 2/2026, de 9 de abril, por la que se modifica la Ley 5/2005, de 27 de junio, de Ordenación del Servicio Farmacéutico de Castilla-La Mancha.
#> 6                                                                                                                                                                                           Ley 3/2026, de 30 de abril, de modificación de la Ley 3/2019, de 22 de marzo, del Estatuto de las Personas Consumidoras en Castilla-La Mancha.
#>   pages
#> 1    59
#> 2     5
#> 3     1
#> 4    32
#> 5    14
#> 6     9
```

If we are interested on a publication we can obtain the url of the
publication with:

``` r
# Say we are interested on the first result:
pdfs <- url_publications(sumario_hoy[1, ])
pdfs # And we can download it with download.file(pdfs)
#> [1] "https://boe.es/boe/dias/2026/11/09/pdfs/BOE-A-2026-23384.pdf"
```

We can open the publication from R with:

``` r
open_publications(sumario_hoy)
```

If we need to know the BOE code of a publication we can do so with:

``` r
sumario_nbo(as.Date("2019/11/15"))
#> [1] "BOE-S-20191115"
sumario_nbo(as.Date("2019/11/15"), journal = "BORME")
#> [1] "BORME-S-20191115"
# The codes of publication is the year and the number of said publication
sumario_cve("2017", "275") 
#> [1] "BOE-S-2017-275"
sumario_cve("2017", "275", journal = "BORME") 
#> [1] "BORME-S-2017-275"
anuncio_cve("2012", "32498") 
#> [1] "BOE-B-2012-32498"
disposicion_cve("2012", "32498")
#> [1] "BOE-A-2012-32498"
```

## Code of Conduct

Please note that the BOE project is released with a [Contributor Code of
Conduct](https://contributor-covenat.org/version/1/0/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
