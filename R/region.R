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

#' Gives information grouped by region
#'
#' @param code   The account code to use
#' @param filter The filter for the data
#' @param file   An optional file name to save a CSV file to
#' @param save   Set to TRUE if you'd like a dialog file to choose where to save your CSV
#' @param truncateAt Optional number of results - rest will become "Others". This takes the
#'                   top regions based on the volume of mentions from the site.
#'
#' @return A tibble of your data
#' @export
#'
#' @examples
#'
#' regions_metric("QUIR01BA", "published inthelast week  and brand isorchildof 10006")
regions_metric <- function(code, filter, file = NULL, save = FALSE, truncateAt = NULL) {
  assert_that(is.string(code))
  assert_that(is.string(filter))
  assert_that(is.null(file) || is.string(file), msg = "File name must be a string")

  # For devtools::check
  region <- NULL; region.id <- NULL; region.name <- NULL; engagement <- NULL; . <- NULL;
  mentionCount <- NULL; totalEngagement <- NULL; totalOTS <- NULL; totalSentiment <- NULL;
  netSentiment <- NULL; percentage <- NULL; netSentimentPercent <- NULL;

  data <- account(code) %>%
    count_mentions(filter, groupBy = region,
                   select = c(mentionCount, engagement, totalSentiment, totalOTS))

  if (!is.null(truncateAt)) {
    assert_that(is.number(truncateAt))
    top <- data %>% top_n(n = truncateAt, wt=mentionCount)
    others <- data %>%
      top_n(n=-(nrow(.)-truncateAt), wt=mentionCount) %$%
      tibble(region.id = "OTHER",
             region.name = "Others",
             mentionCount = sum(mentionCount, na.rm = TRUE),
             totalEngagement = sum(totalEngagement, na.rm = TRUE),
             totalSentiment = sum(totalSentiment, na.rm = TRUE),
             totalOTS = sum(totalOTS, na.rm = TRUE))
    data <- bind_rows(top, others)
  }

  data %<>%
    rename(id = region.id,
           region = region.name,
           count = mentionCount,
           engagement = totalEngagement,
           netSentiment = totalSentiment,
           ots = totalOTS) %>%
    mutate(netSentimentPercent = ifelse(count == 0, 0, netSentiment / count),
           percentage = (if (sum(count, na.rm = TRUE) == 0) 0 else count / sum(count, na.rm = TRUE))) %>%
    tidyr::replace_na(list(region = "Unknown",
                           count = 0, engagement = 0,
                           percentage = 0, netSentimentPercent = 0,
                           netSentiment = 0, ots = 0)) %>%
    select(id, region, everything())

  if (save) file = rstudioapi::selectFile(caption = "Save as",
                                          filter = "CSV Files (*.csv)",
                                          existing = FALSE)
  if (save && is.null(file)) {
    warn("Saving of file cancelled")
  }

  if (!is.null(file)) {
    data %>%
      mutate(percentage = scales::percent(percentage),
             netSentimentPercent = scales::percent(netSentimentPercent)) %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}

