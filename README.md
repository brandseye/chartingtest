
<!-- README.md is generated from README.Rmd. Please edit that file -->
Charting Test
=============

Provides charting libraries for BrandsEye.

Installing
==========

You need to have both [R](https://cran.rstudio.com/) and [RStudio](https://www.rstudio.com/products/rstudio/download/) installed.

This library, when plotting things, also uses the [Open Sans](https://fonts.google.com/specimen/Open+Sans) and [Nunito Sans](https://fonts.google.com/specimen/Nunito+Sans) fonts, which if you don't have installed, you can get from Google Fonts.

You can install the this library using the `devtools` package:

``` r
# Install the devtools package
install.packages("devtools")
library(devtools)

# Install the library
install_github("brandseye/chartingtest")

# If you have never used brandseyer before, you probably need to authenticate
# the first time you install this library. 
brandseyer::authenticate(key = "<my api key>", save = TRUE)

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
    ## 1 2018-06-10 00:00:00   948   280           292            12          644
    ## 2 2018-06-11 00:00:00  1549   384           406            22         1122
    ## 3 2018-06-12 00:00:00  1703   393           452            59         1193
    ## 4 2018-06-13 00:00:00  2433   450           491            41         1901
    ## 5 2018-06-14 00:00:00  2289   357           457           100         1732
    ## 6 2018-06-15 00:00:00  1320   345           384            39          897
    ## 7 2018-06-16 00:00:00   974   190           212            22          740
    ## 8 2018-06-17 00:00:00   287    73            73             0          214
    ## # ... with 1 more variable: unknownCount <int>

What data is available so far?
==============================

You can find a list of functions that can provide data for you online, [here](reference/index.html).

The first time you use this
===========================

The first time that you use this library, you'll probably have to authenticate yourself so that it knows who you are and what accounts you have access to. You can do that by getting your API key from mash, and running

``` r
brandseyer::authenticate(key = "<my api key>", save = TRUE)
```

You only have to do this once. It will save your API key to reuse it again in the future.

Code of Conduct
===============

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

License
-------

This is copyright BrandsEye, and licensed under the MIT license. See the license files for details.
