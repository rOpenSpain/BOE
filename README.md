
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
devtools::install_github("llrs/BOE")
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
#>         date sumario_nbo   sumario_code section
#> 1 2019-12-16         301 BOE-S-2019-301       1
#> 2 2019-12-16         301 BOE-S-2019-301       1
#> 3 2019-12-16         301 BOE-S-2019-301      2A
#> 4 2019-12-16         301 BOE-S-2019-301      2A
#> 5 2019-12-16         301 BOE-S-2019-301      2A
#> 6 2019-12-16         301 BOE-S-2019-301      2A
#>                                                              section_number
#> 1                                                I. Disposiciones generales
#> 2                                                I. Disposiciones generales
#> 3 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 4 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 5 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 6 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#>                                                     departament departament_etq
#> 1 MINISTERIO DE ASUNTOS EXTERIORES, UNIÓN EUROPEA Y COOPERACIÓN            9562
#> 2                       MINISTERIO PARA LA TRANSICIÓN ECOLÓGICA            9566
#> 3                            CONSEJO GENERAL DEL PODER JUDICIAL            1820
#> 4                                                 UNIVERSIDADES             310
#> 5                                                 UNIVERSIDADES             310
#> 6                                                 UNIVERSIDADES             310
#>                                   epigraph
#> 1 Acuerdos internacionales administrativos
#> 2          Productos petrolíferos. Precios
#> 3                            Nombramientos
#> 4                            Nombramientos
#> 5                            Nombramientos
#> 6                            Nombramientos
#>                                                                                                                                                                                                                                                                                                                                                text
#> 1 Acuerdo entre el Ministerio de Trabajo, Migraciones y Seguridad Social del Reino de España y la Organización Internacional para las Migraciones (OIM) para la realización de proyectos en las áreas temáticas de reasentamiento, retorno voluntario asistido y reintegración, reubicación e integración, hecho en Madrid el 20 de agosto de 2019.
#> 2                                                                                                                       Resolución de 11 de diciembre de 2019, de la Dirección General de Política Energética y Minas, por la que se publican los nuevos precios de venta, antes de impuestos, de los gases licuados del petróleo por canalización.
#> 3                                                                                                                                                                                     Real Decreto 649/2019, de 8 de noviembre, por el que se nombra a don Jesús María Chamorro González, Presidente del Tribunal Superior de Justicia de Asturias.
#> 4                                                                                                                                                                                             Resolución de 25 de noviembre de 2019, de la Universidad de Córdoba, por la que se nombra Profesor Titular de Universidad a don Manuel Rivera Mateos.
#> 5                                                                                                                                                                               Resolución de 26 de noviembre de 2019, de la Universidad de Castilla-La Mancha, por la que se nombra Catedrático de Universidad a don Ginés Damián Moreno Valverde.
#> 6                                                                                                                      Resolución de 26 de noviembre de 2019, conjunta de la Universidad de Sevilla y el Servicio Andaluz de Salud, por la que se nombra Profesor Titular de Universidad con plaza vinculada a don Francisco Javier Medrano Ortega.
#>        publication pages
#> 1 BOE-A-2019-17952    98
#> 2 BOE-A-2019-17953     3
#> 3 BOE-A-2019-17954     1
#> 4 BOE-A-2019-17955     1
#> 5 BOE-A-2019-17956     1
#> 6 BOE-A-2019-17957     1
```

If we are interested on a publication we can obtain the url of the
publication with:

``` r
# Say we are interested on the first result:
pdfs <- url_publications(sumario_hoy[1, ])
pdfs # And we can download it with download.file(pdfs)
#> [1] "https://boe.es/boe/dias/2019/12/16/pdfs/BOE-A-2019-17952.pdf"
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
