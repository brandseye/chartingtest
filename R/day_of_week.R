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

#' Get data for determining the best day of the week to post
#'
#' @param account An account code
#' @param filter A filter to use
#' @param file A filename to save the data to as a CSV
#' @param save Set to true to be given a save file dialog.
#'
#' @return A tibble of data
#' @export
#'
#' @examples
#'
#' day_of_week("QUIR01BA", "published inthelast week")
#'
day_of_week <- function(account, filter, file = NULL, save = FALSE) {
  assert_that(!missing(filter) && is.string(filter), msg = "No filter has been provided")

  # For devtools::check
  published <- NULL; count <- NULL; day <- NULL;
  positiveCount <- NULL; negativeCount <- NULL; engagement <- NULL;

  days <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")

  data <- brandseyer::account_count(account, filter, groupby="published",
                                    include = c("sentiment-count", "engagement")) %>%
    mutate(day = factor(days[lubridate::wday(published, week_start = 1)],
                        levels = days, ordered = TRUE)) %>%
    group_by(day) %>%
    summarise(count = sum(count, na.rm = TRUE),
              net = sum(positiveCount, na.rm = TRUE) - sum(negativeCount, na.rm = TRUE),
              engagement = sum(engagement, na.rm = TRUE))

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
