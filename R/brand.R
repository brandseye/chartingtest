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

#' Returns data grouped by brand
#'
#' @param code   The account code to use
#' @param filter The filter for the data
#' @param file   An optional file name to save a CSV file to
#' @param save   Set to TRUE if you'd like a dialog file to choose where to save your CSV
#'
#' @return A tibble of your data
#' @export
#'
#' @examples
#'
#' brand_metric("QUIR01BA", "published inthelast week  and brand isorchildof 10006")
brand_metric <- function(code, filter, file = NULL, save = FALSE) {
  assert_that(is.string(code))
  assert_that(is.string(filter))
  assert_that(is.null(file) || is.string(file), msg = "File name must be a string")

  # For devtools::check
  positiveCount <- NULL; negativeCount <- NULL; neutralCount <- NULL; net <- NULL;
  positivePercent <- NULL; negativePercent <- NULL; neutralPercent <- NULL;
  totalPositive <- NULL; totalNegative <- NULL; totalNeutral <- NULL;
  netSentiment <- NULL; mentionCount <- NULL; totalSentiment <- NULL;
  positiveSentiment <- NULL; negativeSentiment <- NULL; neutralSentiment <- NULL;
  . <- NULL; uniqueAuthors <- NULL; authorIdCount <- NULL; authorId <- NULL;
  netSentimentPercent <- NULL; brand <- NULL; brand.id <- NULL; brand.name <- NULL;
  totalOTS <- NULL;

  data <- account(code) %>%
    count_mentions(filter = filter,
                   groupBy = brand,
                   select=c(mentionCount,
                            totalSentiment, totalPositive, totalNegative, totalNeutral,
                            authorId, totalOTS)) %>%
    mutate(netSentiment = totalSentiment,
           count = mentionCount,
           netSentimentPercent = ifelse(count == 0, 0, netSentiment / count),
           uniqueAuthors = authorIdCount,
           positiveSentiment = totalPositive,
           negativeSentiment = totalNegative,
           neutralSentiment = totalNeutral,
           positivePercent = positiveSentiment / ifelse(count == 0, 1, count),
           negativePercent = negativeSentiment / ifelse(count == 0, 1, count),
           neutralPercent = neutralSentiment / ifelse(count == 0, 1, count)) %>%
    select(brand.id, brand.name,
           count, netSentiment, netSentimentPercent, uniqueAuthors, totalOTS,
           positiveSentiment, positivePercent,
           negativeSentiment, negativePercent,
           neutralSentiment, neutralPercent)

  if (save) file = rstudioapi::selectFile(caption = "Save as",
                                          filter = "CSV Files (*.csv)",
                                          existing = FALSE)
  if (save && is.null(file)) {
    warn("Saving of file cancelled")
  }

  if (!is.null(file)) {
    data %>%
      dplyr::mutate(netSentimentPercent=scales::percent(netSentimentPercent),
                    positivePercent=scales::percent(positivePercent),
                    neutralPercent=scales::percent(neutralPercent),
                    negativePercent=scales::percent(negativePercent)) %>%
      replace(is.na(.), 0) %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}
