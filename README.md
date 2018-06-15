
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
    ## 1 2018-06-08 00:00:00  1467   456           494            38          935
    ## 2 2018-06-09 00:00:00  1033   339           355            16          662
    ## 3 2018-06-10 00:00:00   947   280           292            12          643
    ## 4 2018-06-11 00:00:00  1547   384           406            22         1120
    ## 5 2018-06-12 00:00:00  1699   394           452            58         1190
    ## 6 2018-06-13 00:00:00  2426   451           491            40         1895
    ## 7 2018-06-14 00:00:00  2267   356           455            99         1713
    ## 8 2018-06-15 00:00:00   499   141           156            15          328
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

License
-------

This is copyright BrandsEye, and licensed under the MIT license. See the license files for details.
