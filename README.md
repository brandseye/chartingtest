
<!-- README.md is generated from README.Rmd. Please edit that file -->
Charting Test
=============

Provides CSV data export and charting libraries for BrandsEye.

This library is currently under development, and bits of it may change. It's built on top of [brandseyer2](https://brandseye.github.io/brandseyer2) (which allows arbitrary data to be pulled from the BrandsEye APIs), but provides easy means for exporting CSV data in a friendly manner.

Installing
==========

The first steps to installing the library is to make sure that you have R and RStudio installed, along with the various fonts used in the charts. Finally, install this charting library itself. You can work your way through the following steps:

1.  Download and install [R](https://cran.rstudio.com/).

2.  Download and install [RStudio](https://www.rstudio.com/products/rstudio/download/). If you already have a version of RStudio installed, please make sure it's more recent than version 1.1.287. If you're unsure, you can update RStudio from it's *Help* menu.

3.  You need to install the fonts that the library uses when plotting. These are [Open Sans](https://fonts.google.com/specimen/Open+Sans) and [Nunito Sans](https://fonts.google.com/specimen/Nunito+Sans) fonts, which if you don't have installed, you can get from Google Fonts.

4.  You can install the this library using the `devtools` package. You should do this from inside of RStudio, in the area called the Console. You can copy and paste the code below, and press enter to run it:

    ``` r
    # Install the devtools package
    install.packages("devtools")
    library(devtools)

    # Install the library
    install_github("brandseye/chartingtest")
    ```

5.  The next step is to authenticate yourself. This lets the library know who you are and what accounts you have access to. You do that by supplying your API key, as in the code below. Your API key is like a password to all of your accounts. Please do not share this with clients, since it would give them access to all of our accounts. You can find your API key by logging in to mash, and looking yourself up in the user list. Place your API key inbetween the quotes in the code below, and run it in the RStudio console.

    ``` r
    # If you have never used brandseyer before, you probably need to authenticate
    # the first time you install this library. 
    brandseyer2::authenticate(key = "<my api key>", save = TRUE)
    ```

    You only have to do this once. It will save your API key to reuse it again in the future.

6.  Finally, you can load the charting library by copying and pasting the line below.

    ``` r
    # Load the library
    library(chartingtest)
    ```

Getting data
============

All data can be downloaded and saved as a CSV (or plotted) using a single line of R. For example, here we get data for plotting volume against sentiment for the `QUIR01BA` account, using a particular filter, and also asking to save the data.

``` r
library(chartingtest)
# Ask for data. Tell it that you want to save to file as well
volume_sentiment_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006", save = TRUE)
```

And this is what the data would look like in R itself (there will be similar columns in the CSV).

``` r
library(chartingtest)
volume_sentiment_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006")
```

What data is available so far?
==============================

You can find a list of functions that can provide data for you online, [here](reference/index.html).

Adding fonts to R
=================

If you're using the library for the first time, you'll need to add the required fonts. First download and install them on your machine:

-   [Open Sans](https://fonts.google.com/specimen/Open+Sans)
-   [Nunito Sans](https://fonts.google.com/specimen/Nunito+Sans)

Then add them to R using the `extrafont` package:

``` r
# Install the extrafont package
install.packages("extrafont")
library(extrafont)

# Import fonts into R
font_import(pattern="OpenSans")
font_import(pattern="NunitoSans")
```

Keeping R up to date
====================

If you're using R on windows, one convenient way to keep things up to date is to use the [InstallR](https://github.com/talgalili/installr) library.

When a new version of R is out, you can update R by installing `InstallR` and running:

``` r
library("installr")
updateR()
```

Updating chartingtest
=====================

If you would like to get a new version of `chartingtest` installed, run the following from your RStudio Console.

``` r
devtools::install_github("brandseye/brandseyer2")     # Update brandseyer2
devtools::install_github("brandseye/chartingtest")    # Update chartingtest
```

Recent Changes
==============

We have a [ChangeLog](news/index.html) file that you can read to find the most recent changes to the library.

Code of Conduct
===============

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

License
=======

This is copyright BrandsEye, and licensed under the MIT license. See the license files for details.
