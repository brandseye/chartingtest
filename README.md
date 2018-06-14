
<!-- README.md is generated from README.Rmd. Please edit that file -->
Charting Test
=============

Provides charting libraries for BrandsEye.

Installing
==========

You can install the this library using the `devtools` package:

``` r
# Install the devtools package
install.packages("devtools")
library(devtools)

# Install the library
install_github("brandseye/chartingtest")

# Load the library
library(chartingtest)
```

Example
=======

``` r
# load the library
library(chartingtest)

# Ask for data. Tell it that you want to save to file as well
volume_sentiment("QUIR01BA", "published inthelast week", save = TRUE)
```

And this is what the data would look like in R itself (there will be similar columns in the CSV).

    ## # A tibble: 8 x 7
    ##   published           count   net positiveCount negativeCount neutralCount
    ##   <dttm>              <int> <int>         <int>         <int>        <int>
    ## 1 2018-06-07 00:00:00  1688   514           546            32         1110
    ## 2 2018-06-08 00:00:00  1467   455           494            39          934
    ## 3 2018-06-09 00:00:00  1033   339           355            16          662
    ## 4 2018-06-10 00:00:00   946   280           292            12          642
    ## 5 2018-06-11 00:00:00  1543   382           404            22         1118
    ## 6 2018-06-12 00:00:00  1692   392           450            58         1185
    ## 7 2018-06-13 00:00:00  2421   451           491            40         1890
    ## 8 2018-06-14 00:00:00  1312   125           197            72         1043
    ## # ... with 1 more variable: unknownCount <int>

License
-------

This is copyright BrandsEye, and licensed under the MIT license. See the license files for details.
