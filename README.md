
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

You can see examples of what is cappable on the vignette or on this
[webiste](https://llrs.github.io/BOE_historico/)

## Installation

You can install it from github with:

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
#>         date sumario_nbo   sumario_code section
#> 1 2020-06-01         154 BOE-S-2020-154       1
#> 2 2020-06-01         154 BOE-S-2020-154       1
#> 3 2020-06-01         154 BOE-S-2020-154      2A
#> 4 2020-06-01         154 BOE-S-2020-154      2A
#> 5 2020-06-01         154 BOE-S-2020-154      2A
#> 6 2020-06-01         154 BOE-S-2020-154      2A
#>                                                              section_number
#> 1                                                I. Disposiciones generales
#> 2                                                I. Disposiciones generales
#> 3 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 4 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 5 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 6 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#>                                            departament departament_etq
#> 1                                  JEFATURA DEL ESTADO            7723
#> 2 MINISTERIO DE TRANSPORTES, MOVILIDAD Y AGENDA URBANA            9572
#> 3                               MINISTERIO DE JUSTICIA            4810
#> 4                               MINISTERIO DE JUSTICIA            4810
#> 5                               MINISTERIO DE JUSTICIA            4810
#> 6                               MINISTERIO DE JUSTICIA            4810
#>                     epigraph
#> 1       Ingreso mínimo vital
#> 2 Puertos de interés general
#> 3                 Reingresos
#> 4                Situaciones
#> 5                Situaciones
#> 6                Situaciones
#>                                                                                                                                                                                                                                          text
#> 1                                                                                                                                                   Real Decreto-ley 20/2020, de 29 de mayo, por el que se establece el ingreso mínimo vital.
#> 2 Resolución de 8 de mayo de 2020, de Puertos del Estado, por la que se modifica el Anexo I de la Orden FOM/1194/2011, de 29 de abril, por la que se regula el procedimiento integrado de escala de buques en los puertos de interés general.
#> 3                                                                                                      Orden JUS/468/2020, de 23 de abril, por la que se reingresa al servicio activo en la Carrera Fiscal a doña Elisabet Jiménez Cabestany.
#> 4                                                                                             Orden JUS/469/2020, de 31 de marzo, por la que se declara en situación de excedencia voluntaria en la Carrera Fiscal a doña Emma Ruiz Martínez.
#> 5                                                                                          Orden JUS/470/2020, de 31 de marzo, por la que se declara en situación de excedencia voluntaria en la Carrera Fiscal a doña Elena Martínez Castro.
#> 6                                                                      Orden JUS/471/2020, de 7 de abril, por la que se declara en la situación administrativa de servicios especiales en la Carrera Fiscal a doña María de las Heras García.
#>       publication pages
#> 1 BOE-A-2020-5493    44
#> 2 BOE-A-2020-5494     2
#> 3 BOE-A-2020-5495     1
#> 4 BOE-A-2020-5496     1
#> 5 BOE-A-2020-5497     1
#> 6 BOE-A-2020-5498     1
```

If we are interested on a publication we can obtain the url of the
publication with:

``` r
# Say we are interested on the first result:
pdfs <- url_publications(sumario_hoy[1, ])
pdfs # And we can download it with download.file(pdfs)
#> [1] "https://boe.es/boe/dias/2020/06/01/pdfs/BOE-A-2020-5493.pdf"
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
