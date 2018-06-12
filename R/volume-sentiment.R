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

#' Returns the data for creating a volume/sentiment
#'
#' @param code   The account code to use
#' @param filter The filter for the data.
#' @param group  An optional string to group data by. Can be "day", "week", "month"
#' @param file   An optional file name to save a CSV file to.
#'
#' @return A tibble of your data
#' @export
volume_sentiment <- function(code, filter, group = "day", file = NULL) {
  assert_that(is.string(code))
  assert_that(is.string(filter))
  assert_that(group %in% c("day", "week", "month"))
  assert_that(is.null(file) || is.string(file), msg = "File name must be a string")

  # For devtools::check
  published <- NULL; positiveCount <- NULL; negativeCount <- NULL;

  data <- brandseyer::account_count(code, filter = filter,
                                    groupby = glue("published[{group}]"),
                                    include="sentiment-count") %>%
    dplyr::mutate(net = positiveCount - negativeCount,
                  published = lubridate::force_tz(published, brandseyer::account_timezone(code)))

  if (!is.null(file)) {
    data %>%
      dplyr::mutate(published = format(published, "%F %R")) %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}

plot_volume_sentiment <- function(code, filter, group = "day") {
  data <- volume_sentiment(code, filter, group)

  ggplot(data, aes(x = published, y = count)) +
    geom_bar(stat = "identity", fill = MID_GREY) +
    theme_brandseye()

}
