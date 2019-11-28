
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
today <- Sys.Date()
sumario_hoy <- retrieve_sumario(today)
head(sumario_hoy)
#>         date sumario_nbo   sumario_code section             section_number
#> 1 2019-11-28         286 BOE-S-2019-286       1 I. Disposiciones generales
#> 2 2019-11-28         286 BOE-S-2019-286       1 I. Disposiciones generales
#> 3 2019-11-28         286 BOE-S-2019-286       1 I. Disposiciones generales
#> 4 2019-11-28         286 BOE-S-2019-286       1 I. Disposiciones generales
#> 5 2019-11-28         286 BOE-S-2019-286       1 I. Disposiciones generales
#> 6 2019-11-28         286 BOE-S-2019-286       1 I. Disposiciones generales
#>                                                     departament departament_etq
#> 1 MINISTERIO DE ASUNTOS EXTERIORES, UNIÓN EUROPEA Y COOPERACIÓN            9562
#> 2 MINISTERIO DE ASUNTOS EXTERIORES, UNIÓN EUROPEA Y COOPERACIÓN            9562
#> 3                                        MINISTERIO DE JUSTICIA            4810
#> 4         MINISTERIO DE TRABAJO, MIGRACIONES Y SEGURIDAD SOCIAL            9564
#> 5                   MINISTERIO DE INDUSTRIA, COMERCIO Y TURISMO            5250
#> 6                                COMUNIDAD AUTÓNOMA DE CATALUÑA            8070
#>                               epigraph
#> 1             Tratados internacionales
#> 2             Tratados internacionales
#> 3                      Juzgados de Paz
#> 4 Formación profesional para el empleo
#> 5                         Subvenciones
#> 6                         Organización
#>                                                                                                                                                                                                                                                                                                                                                                                                    text
#> 1                                                                     Entrada en vigor del Tercer Protocolo adicional al Acuerdo por el que se establece una Asociación entre la Comunidad Europea, y sus Estados miembros, por una parte, y la República de Chile, por otra, para tener en cuenta la adhesión de la República de Croacia a la Unión Europea, hecho en Bruselas el 29 de junio de 2017.
#> 2                                                                                                                                                                            Corrección de errores de la Resolución de 30 de octubre de 2019, de la Secretaría General Técnica, sobre aplicación del artículo 24.2 de la Ley 25/2014, de 27 de noviembre, de Tratados y otros Acuerdos Internacionales.
#> 3                                 Orden JUS/1154/2019, de 25 de noviembre, por la que se publica el Acuerdo del Consejo de Ministros de 8 de noviembre de 2019, por el que se fija el módulo para la distribución del crédito que figura en los Presupuestos Generales del Estado para el año 2018 prorrogados para 2019, destinado a subvencionar los gastos de funcionamiento de los juzgados de paz.
#> 4 Corrección de errores de la Orden TMS/369/2019, de 28 de marzo, por la que se regula el Registro Estatal de Entidades de Formación del sistema de formación profesional para el empleo en el ámbito laboral, así como los procesos comunes de acreditación e inscripción de las entidades de formación para impartir especialidades formativas incluidas en el Catálogo de Especialidades Formativas.
#> 5                                                                                                       Real Decreto 671/2019, de 22 de noviembre, por el que se regula la concesión directa de una subvención a la Fundación Real Instituto Elcano de Estudios Internacionales y Estratégicos para la financiación de los gastos de funcionamiento y actividad en el marco de sus fines fundacionales.
#> 6                                                                                                                                                                                                                   Ley 7/2019, de 14 de noviembre, de modificación de la Ley 2/2000, del Consejo del Audiovisual de Cataluña, y de la Ley 11/2007, de la Corporación Catalana de Medios Audiovisuales.
#>        publication pages
#> 1 BOE-A-2019-17093     1
#> 2 BOE-A-2019-17094     1
#> 3 BOE-A-2019-17095     2
#> 4 BOE-A-2019-17096     2
#> 5 BOE-A-2019-17097     5
#> 6 BOE-A-2019-17098     8
```

If we are interested on a publication we can obtain the url of the
publication with:

``` r
# Say we are interested on the first result:
pdfs <- url_publications(sumario_hoy[1, ])
pdfs # And we can download it with download.file(pdfs)
#> [1] "https://boe.es/boe/dias/2019/11/28/pdfs/BOE-A-2019-17093.pdf"
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
