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

#' Get data for determining the best time of day to post (by hour)
#'
#' @param code An account code
#' @param filter A filter to use
#' @param file A filename to save the data to as a CSV
#' @param save Set to true to be given a save file dialog.
#'
#' @return A tibble of data
#' @export
#'
#' @examples
#'
#' time_of_day_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006")
time_of_day_metric <- function(code, filter, file = NULL, save = FALSE) {
  assert_that(!missing(filter) && is.string(filter), msg = "No filter has been provided")

  # For devtools::check
  published <- NULL; hour <- NULL; count <- NULL;
  positiveCount <- NULL; negativeCount <- NULL; engagement <- NULL;

  data <- account(code) %>%
    count_mentions(filter, groupBy=published[HOUR],
                   select = c(totalSentiment, engagement)) %>%
    mutate(hour = lubridate::hour(published)) %>%
    group_by(hour) %>%
    summarise(count = sum(count, na.rm = TRUE),
              totalSentiment = sum(totalSentiment, na.rm = TRUE),
              totalEngagement = sum(totalEngagement, na.rm = TRUE)) %>%
    rename(netSentiment = totalSentiment,
           engagement = totalEngagement)

  if (save) file = rstudioapi::selectFile(caption = "Save as",
                                          filter = "CSV Files (*.csv)",
                                          existing = FALSE)
  if (save && is.null(file)) {
    warn("Saving of file cancelled")
  }

  if (!is.null(file)) {
    readr::write_excel_csv(data, file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}

#' Plots the time of day to post (by hour)
#'
#' @param account An account code
#' @param filter A filter for data
#'
#' @return the ggplot object
#' @export
plot_time_of_day_metric <- function(account, filter) {
  # For devtools::check
  hour <- NULL; count <- NULL; net <- NULL;

  time_of_day_metric(account, filter) %>%
    ggplot(aes(x = hour)) +
    geom_line(aes(y = count, colour = "volume")) +
    geom_line(aes(y = net + 100, colour = "sentiment")) +
    scale_y_continuous(sec.axis = sec_axis(~.-100, name = "Sentiment")) +
    labs(title = "Time of day", x = "Hour of day", y = "Volume") +
    theme_brandseye()
}
