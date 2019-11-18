
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
today <- Sys.Date() -1
sumario_code <- sumario_xml(today) #Code needed to identify it online
sumario_hoy <- tidy_sumario(get_xml(query_xml(sumario_code)))
head(sumario_hoy)
#>       date sumario_nbo   sumario_code section
#> 1 18-11-20         277 BOE-S-2019-277       1
#> 2 18-11-20         277 BOE-S-2019-277       1
#> 3 18-11-20         277 BOE-S-2019-277       1
#> 4 18-11-20         277 BOE-S-2019-277      2A
#> 5 18-11-20         277 BOE-S-2019-277      2A
#> 6 18-11-20         277 BOE-S-2019-277      2A
#>                                                              section_number
#> 1                                                I. Disposiciones generales
#> 2                                                I. Disposiciones generales
#> 3                                                I. Disposiciones generales
#> 4 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 5 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#> 6 II. Autoridades y personal. - A. Nombramientos, situaciones e incidencias
#>                                       departament departament_etq
#> 1         MINISTERIO PARA LA TRANSICIÓN ECOLÓGICA            9566
#> 2         MINISTERIO PARA LA TRANSICIÓN ECOLÓGICA            9566
#> 3                            COMUNITAT VALENCIANA            8162
#> 4                           MINISTERIO DE FOMENTO            3210
#> 5 MINISTERIO DE AGRICULTURA, PESCA Y ALIMENTACIÓN            3120
#> 6                                   UNIVERSIDADES             310
#>                                   epigraph
#> 1          Productos petrolíferos. Precios
#> 2          Productos petrolíferos. Precios
#> 3 Espectáculos y establecimientos públicos
#> 4                                 Destinos
#> 5                                 Destinos
#> 6                            Nombramientos
#>                                                                                                                                                                                                                                                                                                                                                                                            text
#> 1                                                                                                                                                                   Resolución de 11 de noviembre de 2019, de la Dirección General de Política Energética y Minas, por la que se publican los nuevos precios de venta, antes de impuestos, de los gases licuados del petróleo por canalización.
#> 2 Resolución de 11 de noviembre de 2019, de la Dirección General de Política Energética y Minas, por la que se publican los nuevos precios máximos de venta, antes de impuestos, de los gases licuados del petróleo envasados, en envases de carga igual o superior a 8 kg., e inferior a 20 kg., excluidos los envases de mezcla para usos de los gases licuados del petróleo como carburante.
#> 3                                                                                                                                                                                       Ley 7/2019, de 24 de octubre, por la que se deroga la Disposición adicional quinta de la Ley 14/2010, de 3 de diciembre, de espectáculos públicos, actividades recreativas y establecimientos públicos.
#> 4                                                                                                                                                              Resolución de 11 de noviembre de 2019, de la Secretaría de Estado de Infraestructuras, Transporte y Vivienda, por la que se resuelve la convocatoria de libre designación, efectuada por Resolución de 26 de septiembre de 2019.
#> 5                                                                                                                                                                                                                 Resolución de 8 de noviembre de 2019, de la Subsecretaría, por la que se resuelve la convocatoria de libre designación, efectuada por Resolución de 24 de septiembre de 2019.
#> 6                                                                                                                                                                                                                                 Resolución de 28 de octubre de 2019, de la Universidad de Cantabria, por la que se nombra Catedrática de Universidad a doña María Concepción López Fernández.
#>        publication pages
#> 1 BOE-A-2019-16519     3
#> 2 BOE-A-2019-16520     2
#> 3 BOE-A-2019-16521     2
#> 4 BOE-A-2019-16522     2
#> 5 BOE-A-2019-16523     2
#> 6 BOE-A-2019-16524     1

# Say we are interested on the first result:
year <- format(today, "%Y")
month <- format(today, "%m")
day <- format(today, "%d")
publication_code <- sumario_hoy[1, "publication"]
pdf <- query_pdf(year, month, day, publication_code)
pdf
#> [1] "https://boe.es/boe/dias/2019/11/18/pdfs/BOE-A-2019-16519.pdf"
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
