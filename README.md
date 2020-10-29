
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BOE

<!-- badges: start -->

[![R build
status](https://github.com/rOpenSpain/BOE/workflows/R-CMD-check/badge.svg)](https://github.com/rOpenSpain/BOE/actions)
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
identifiers of some elements. The most important data is the sumario
(summary) which can be retrieved by the date:

``` r
library("BOE")
today <- Sys.Date()
sumario_hoy <- retrieve_sumario(today)
head(sumario_hoy)
#>         date sumario_nbo   sumario_code section
#> 1 2020-10-29         286 BOE-S-2020-286       1
#> 2 2020-10-29         286 BOE-S-2020-286       1
#> 3 2020-10-29         286 BOE-S-2020-286      2A
#> 4 2020-10-29         286 BOE-S-2020-286      2A
#> 5 2020-10-29         286 BOE-S-2020-286      2A
#> 6 2020-10-29         286 BOE-S-2020-286      2A
#>                                                              section_number
#> 1                                                I. Disposiciones generales
#> 2                                                I. Disposiciones generales
#> 3 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 4 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 5 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 6 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#>                                                     departament departament_etq
#> 1          MINISTERIO DE TRANSPORTES, MOVILIDAD Y AGENDA URBANA            9572
#> 2          MINISTERIO DE POLÍTICA TERRITORIAL Y FUNCIÓN PÚBLICA            9561
#> 3                            CONSEJO GENERAL DEL PODER JUDICIAL            1820
#> 4                            CONSEJO GENERAL DEL PODER JUDICIAL            1820
#> 5                            CONSEJO GENERAL DEL PODER JUDICIAL            1820
#> 6 MINISTERIO DE ASUNTOS EXTERIORES, UNIÓN EUROPEA Y COOPERACIÓN            9562
#>                   epigraph
#> 1          Red ferroviaria
#> 2 Oferta de empleo público
#> 3            Nombramientos
#> 4            Nombramientos
#> 5            Nombramientos
#> 6                 Destinos
#>                                                                                                                                                                                                                                             text
#> 1                                                                                                                                         Real Decreto 929/2020, de 27 de octubre, sobre seguridad operacional e interoperabilidad ferroviarias.
#> 2                                                                                                                                   Real Decreto 936/2020, de 27 de octubre, por el que se aprueba la oferta de empleo público para el año 2020.
#> 3   Acuerdo de 22 de octubre de 2020, de la Comisión Permanente del Consejo General del Poder Judicial, por el que se nombra Jueces/zas sustitutos/as para el año judicial 2020/2021, en el ámbito del Tribunal Superior de la Región de Murcia.
#> 4 Acuerdo de 22 de octubre de 2020, de la Comisión Permanente del Consejo General del Poder Judicial, por el que se nombra Jueza sustituta para el año judicial 2020/2021, en el ámbito del Tribunal Superior de Justicia de Castilla-La Mancha.
#> 5        Acuerdo de 22 de octubre de 2020, de la Comisión Permanente del Consejo General del Poder Judicial, por el que se nombra Magistrado suplente para el año judicial 2020/2021, en el ámbito del Tribunal Superior de Justicia de Navarra.
#> 6                                                                        Resolución de 19 de octubre de 2020, de la Subsecretaría, por la que se resuelve la convocatoria de libre designación, efectuada por Resolución de 22 de julio de 2020.
#>        publication pages
#> 1 BOE-A-2020-13115   155
#> 2 BOE-A-2020-13116    21
#> 3 BOE-A-2020-13117     1
#> 4 BOE-A-2020-13118     1
#> 5 BOE-A-2020-13119     1
#> 6 BOE-A-2020-13120     2
```

If we are interested on a publication we can obtain the url of the
publication with:

``` r
# Say we are interested on the first result:
pdfs <- url_publications(sumario_hoy[1, ])
pdfs # And we can download it with download.file(pdfs)
#> [1] "https://boe.es/boe/dias/2020/10/29/pdfs/BOE-A-2020-13115.pdf"
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
