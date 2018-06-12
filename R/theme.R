# Copyright (c) 2018 BrandsEye
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

LIGHT_GREY  <- "#e9e9e9"  # gridlines, bars and columns, neutral sentiment
MID_GREY    <- "#c0c0c0"  # table borders, bars and columns if light grey is too lightGrey
DARK_GREY   <- "#444444"  # All text

#' Provides a BrandsEye ggplot2 theme.
#'
#' This is still a work in progress, but should provide a ggplot2 theme
#' for charts.
#'
#' @return The theme object.
#' @export
theme_brandseye <- function() {
  # panel.border = element_blank(),
  theme_light() + theme(text = element_text(family = "Open Sans Light",
                                            colour = DARK_GREY),
                        title = element_text(family = "Nunito Sans"),
                        axis.title = element_text("Open Sans Light"),
                        panel.grid = element_line(colour = LIGHT_GREY),
                        panel.grid.major = element_line(color = LIGHT_GREY),
                        panel.grid.major.x = element_blank(),
                        panel.grid.minor = element_blank())
}



# update_geom_defaults("bar", list(fill = MID_GREY))
