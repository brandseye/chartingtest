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

#' Get data for determining time of day to post (by hour)
#'
#' @param account An account code
#' @param filter A filter to use
#'
#' @return A tibble of data
#' @export
time_of_day <- function(account, filter) {
  assert_that(!missing(filter) && is.string(filter))
  brandseyer::account_count(account, filter, groupby="published[hour]", include = "sentiment-count") %>%
    dplyr::mutate(hour = lubridate::hour(published)) %>%
    dplyr::group_by(hour) %>%
    dplyr::summarise(count = sum(count, na.rm = TRUE),
                     net = sum(positiveCount, na.rm = TRUE) - sum(negativeCount, na.rm = TRUE))
}

#' Plots the time of day to post (by hour)
#'
#' @param account An account code
#' @param filter A filter for data
#'
#' @return the ggplot object
#' @export
plot_time_of_day <- function(account, filter) {
  time_of_day(account, filter) %>%
    ggplot(aes(x = hour, y = count)) +
    geom_line() +
    ggplot2::labs(title = "Time of day", x = "Hour of day")


}
