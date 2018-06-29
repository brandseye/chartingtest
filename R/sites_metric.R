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

#' Gets the 'stats metric' for a given filter
#'
#' @param code An account code
#' @param filter A filter for data
#' @param file   An optional file name to save a CSV file to.
#' @param save   Set to TRUE if you'd like a dialog file to choose where to save your CSV.
#' @param truncateAt Optional number of results - rest will become "Others". This takes the
#'                   top sites based on the volume of mentions from the site.
#'
#' @return A tibble of your data
#' @export
#'
#' @examples
#'
#' sites_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006")


sites_metric <- function(code, filter, file = NULL, save = FALSE, truncateAt = NULL) {

  # For devtools::check
  mentionCount <- NULL; . <- NULL; site <- NULL; engagement <- NULL;
  totalSentiment <- NULL; totalOTS <- NULL; totalEngagement <- NULL;

  ac <- account(code)
  data <- count_mentions(ac, filter, groupBy = site, select = c(mentionCount, engagement, totalSentiment, totalOTS))

  if (!is.null(truncateAt)) {
    assert_that(is.number(truncateAt))
    top <- data %>% top_n(n = truncateAt, wt=mentionCount)
    others <- data %>%
      top_n(n=-(nrow(.)-truncateAt), wt=mentionCount) %$%
      tibble(site="Others",
             mentionCount = sum(mentionCount, na.rm = TRUE),
             totalEngagement = sum(totalEngagement, na.rm = TRUE),
             totalSentiment = sum(totalSentiment, na.rm = TRUE),
             totalOTS = sum(totalOTS, na.rm = TRUE))
    data <- bind_rows(top, others)
  }

  data %<>%
    rename(count = mentionCount,
           engagement = totalEngagement,
           netSentiment = totalSentiment,
           ots = totalOTS)

  if (save) file = rstudioapi::selectFile(caption = "Save as",
                                          filter = "CSV Files (*.csv)",
                                          existing = FALSE)
  if (save && is.null(file)) {
    warn("Saving of file cancelled")
  }

  if (!is.null(file)) {
    data %>%
      readr::write_excel_csv(file, na = "0")
    done(glue("Written your CSV to {file}"))
  }

  data
}
