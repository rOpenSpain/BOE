
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BOE

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/rOpenSpain/BOE.svg?branch=master)](https://travis-ci.org/rOpenSpain/BOE)
[![Codecov test
coverage](https://codecov.io/gh/rOpenSpain/BOE/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenSpain/BOE?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
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
today <- Sys.Date() -1
sumario_hoy <- retrieve_sumario(today)
head(sumario_hoy)
#>         date sumario_nbo  sumario_code section             section_number
#> 1 2020-03-15          68 BOE-S-2020-68       1 I. Disposiciones generales
#> 2 2020-03-15          68 BOE-S-2020-68       1 I. Disposiciones generales
#> 3 2020-03-15          68 BOE-S-2020-68       1 I. Disposiciones generales
#> 4 2020-03-15          68 BOE-S-2020-68       1 I. Disposiciones generales
#> 5 2020-03-15          68 BOE-S-2020-68       1 I. Disposiciones generales
#> 6 2020-03-15          68 BOE-S-2020-68       1 I. Disposiciones generales
#>                                            departament departament_etq
#> 1                                MINISTERIO DE DEFENSA            6110
#> 2                              MINISTERIO DEL INTERIOR            7320
#> 3                              MINISTERIO DEL INTERIOR            7320
#> 4                              MINISTERIO DEL INTERIOR            7320
#> 5 MINISTERIO DE TRANSPORTES, MOVILIDAD Y AGENDA URBANA            9572
#> 6 MINISTERIO DE TRANSPORTES, MOVILIDAD Y AGENDA URBANA            9572
#>                                                 epigraph
#> 1             Estado de alarma. Medidas crisis sanitaria
#> 2       Estado de alarma. Fuerzas y Cuerpos de Seguridad
#> 3         Estado de alarma. Instituciones Penitenciarias
#> 4 Estado de alarma. Sistema Nacional de Protección Civil
#> 5                     Estado de alarma. Medidas urgentes
#> 6                     Estado de alarma. Medidas urgentes
#>                                                                                                                                                                                                                                                                                                               text
#> 1                                                                                           Instrucción de 15 de marzo de 2020, del Ministerio de Defensa, por la que se establecen medidas para la gestión de la situación de crisis sanitaria ocasionada por el COVID-19 en el ámbito del Ministerio de Defensa.
#> 2  Orden INT/226/2020, de 15 de marzo, por la que se establecen criterios de actuación para las Fuerzas y Cuerpos de Seguridad en relación con el Real Decreto 463/2020, de 14 de marzo, por el que se declara el estado de alarma para la gestión de la situación de crisis sanitaria ocasionada por el COVID-19.
#> 3       Orden INT/227/2020, de 15 de marzo, en relación con las medidas que se adoptan en el ámbito de Instituciones Penitenciarias al amparo del Real Decreto 463/2020, de 14 de marzo, por el que se declara el estado de alarma para la gestión de la situación de crisis sanitaria ocasionada por el COVID-19.
#> 4 Orden INT/228/2020, de 15 de marzo, por la que se establecen criterios de aplicación del Real Decreto 463/2020, de 14 de marzo, por el que se declara el estado de alarma para la gestión de la situación de crisis sanitaria ocasionada por el COVID-19, en el ámbito del Sistema Nacional de Protección Civil.
#> 5                                                                             Orden TMA/229/2020, de 15 de marzo, por la que dictan disposiciones respecto al acceso de los transportistas profesionales a determinados servicios necesarios para facilitar el transporte de mercancías en el territorio nacional.
#> 6                                                                                                                   Orden TMA/230/2020, de 15 de marzo, por la que se concreta la actuación de las autoridades autonómicas y locales respecto de la fijación de servicios de transporte público de su titularidad.
#>       publication pages
#> 1 BOE-A-2020-3693     3
#> 2 BOE-A-2020-3694    10
#> 3 BOE-A-2020-3695     1
#> 4 BOE-A-2020-3696     2
#> 5 BOE-A-2020-3697     2
#> 6 BOE-A-2020-3698     2
```

If we are interested on a publication we can obtain the url of the
publication with:

``` r
# Say we are interested on the first result:
pdfs <- url_publications(sumario_hoy[1, ])
pdfs # And we can download it with download.file(pdfs)
#> [1] "https://boe.es/boe/dias/2020/03/15/pdfs/BOE-A-2020-3693.pdf"
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
