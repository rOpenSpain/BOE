
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

This is a basic example which shows you how to solve find the
identifiers of some elements. The most important data is the sumario
(summary) which can be retrieved by the date:

``` r
library("BOE")
today <- Sys.Date()
sumario_code <- sumario_xml(today) #Code needed to identify it online
sumario_hoy <- tidy_sumario(get_xml(query_xml(sumario_code)))
head(sumario_hoy)
#>       date sumario_nbo   sumario_code section             section_number
#> 1 19-11-20         278 BOE-S-2019-278       1 I. Disposiciones generales
#> 2 19-11-20         278 BOE-S-2019-278       1 I. Disposiciones generales
#> 3 19-11-20         278 BOE-S-2019-278       1 I. Disposiciones generales
#> 4 19-11-20         278 BOE-S-2019-278       1 I. Disposiciones generales
#> 5 19-11-20         278 BOE-S-2019-278       1 I. Disposiciones generales
#> 6 19-11-20         278 BOE-S-2019-278       1 I. Disposiciones generales
#>                                                          departament
#> 1                                                JEFATURA DEL ESTADO
#> 2                                            MINISTERIO DEL INTERIOR
#> 3                    MINISTERIO DE EDUCACIÓN Y FORMACIÓN PROFESIONAL
#> 4                        MINISTERIO DE INDUSTRIA, COMERCIO Y TURISMO
#> 5 MINISTERIO DE LA PRESIDENCIA, RELACIONES CON LAS CORTES E IGUALDAD
#> 6 MINISTERIO DE LA PRESIDENCIA, RELACIONES CON LAS CORTES E IGUALDAD
#>   departament_etq                       epigraph
#> 1            7723 Seguridad Social. Presupuestos
#> 2            7320                   Subvenciones
#> 3            9563                   Subvenciones
#> 4            5250                   Subvenciones
#> 5            9569          Formación profesional
#> 6            9569          Formación profesional
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          text
#> 1                                                                                                                                                                                                                                                                                                                                                                                                Real Decreto-ley 16/2019, de 18 de noviembre, por el que se adoptan medidas relativas a la ejecución del presupuesto de la Seguridad Social.
#> 2                                                                                                                                                                                                                                                                                                                                                                        Real Decreto 655/2019, de 18 de noviembre, por el que se regula la concesión directa de una subvención a la Fundación ANAR (Ayuda a Niños y Adolescentes en Riesgo).
#> 3                                                                                                                                                                                                                                                                                                                       Real Decreto 656/2019, de 18 de noviembre, por el que se regula la concesión directa de diversas subvenciones en el ámbito del Ministerio de Educación y Formación Profesional para el ejercicio presupuestario 2019.
#> 4                                                                                                                                                                                                                                                                                                                                                                           Real Decreto 657/2019, de 18 de noviembre, por el que se regula la concesión directa de subvenciones en materia de turismo para el ejercicio presupuestario 2019.
#> 5 Corrección de errores del Real Decreto 502/2019, de 30 de agosto, por el que se crea como Centro de Referencia Nacional la Escuela de Formación en Artesanía, Restauración y Rehabilitación del Patrimonio Histórico, Artístico y Cultural Albayzín, en las áreas profesionales de Artesanía Tradicional, Recuperación, Reparación y Mantenimiento Artísticos, Fabricación y Mantenimiento de Instrumentos Musicales, y Vidrio y Cerámica Artesanal, de la familia profesional Artes y Artesanías en el ámbito de la formación profesional.
#> 6                                                                                                                                                                                                                                      Corrección de errores del Real Decreto 503/2019, de 30 de agosto, por el que se crea como Centro de Referencia Nacional la Escuela del Mármol de Fines, Almería, en el área profesional de piedra natural, de la familia profesional Industrias Extractivas, en el ámbito de la formación profesional.
#>        publication pages
#> 1 BOE-A-2019-16562     5
#> 2 BOE-A-2019-16563     5
#> 3 BOE-A-2019-16564    16
#> 4 BOE-A-2019-16565    18
#> 5 BOE-A-2019-16566     1
#> 6 BOE-A-2019-16567     1

# Say we are interested on the first result:
year <- format(today, "%Y")
month <- format(today, "%m")
day <- format(today, "%d")
publication_code <- sumario_hoy[1, "publication"]
pdf <- query_pdf(year, month, day, publication_code)
pdf
#> [1] "https://boe.es/boe/dias/2019/11/19/pdfs/BOE-A-2019-16562.pdf"
# And we can download it with download.file(pdf)
```

You can also build the publication code with:

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
