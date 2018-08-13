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
#' @param code An account code
#' @param filter A filter to use
#' @param file A filename to save the data to as a CSV
#' @param save Set to true to be given a save file dialog
#'
#' @return A tibble of data
#' @export
#'
#' @examples
#'
#' day_of_week_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006")
#'
day_of_week_metric <- function(code, filter, file = NULL, save = FALSE) {
  assert_that(!missing(filter) && is.string(filter), msg = "No filter has been provided")

  # For devtools::check
  published <- NULL; count <- NULL; day <- NULL;
  positiveCount <- NULL; negativeCount <- NULL; engagement <- NULL;
  totalEngagement <- NULL; totalSentiment <- NULL;

  days <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")

  data <- account(code) %>%
    count_mentions(filter, groupBy=published,
                   select = c(mentionCount, totalSentiment, engagement)) %>%
    mutate(day = factor(days[lubridate::wday(published, week_start = 1)],
                        levels = days, ordered = TRUE)) %>%
    group_by(day) %>%
    summarise(mentionCount = sum(mentionCount, na.rm = TRUE),
              totalSentiment = sum(totalSentiment, na.rm = TRUE),
              totalEngagement = sum(totalEngagement, na.rm = TRUE)) %>%
    rename(count = mentionCount,
           netSentiment = totalSentiment,
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
