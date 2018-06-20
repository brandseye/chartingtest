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
#' @param code account code
#' @param filter A filter for data
#' @param file   An optional file name to save a CSV file to.
#' @param save   Set to TRUE if you'd like a dialog file to choose where to save your CSV.
#'
#' @return A tibble of your data
#' @export
#'
#' @examples #' get_stats("QUIR01BA", "published inthelast week")


get_stats <- function(code, filter, file = NULL, save = FALSE) {

  # For devtools::check
  authorNameCount <- NULL; mentionCount <- NULL; negativePercent <- NULL; neutralPercent <- NULL; positivePercent <- NULL;
  siteCount <- NULL; totalEngagement <- NULL; totalNegative <- NULL; totalNeutral <- NULL; totalOTS <- NULL;
  totalPositive <- NULL; verifiedCount <- NULL; Metric <- NULL; Value <- NULL;

  ac <- brandseyer2::account(code)

  sentiment_stats <- brandseyer2::count_mentions(ac,
                                                 glue::glue(filter, " AND PROCESS IS VERIFIED"),
                                                 select="mentionCount,totalPositive,totalNeutral,totalNegative") %>%
    dplyr::mutate(positivePercent=scales::percent(totalPositive/mentionCount),
           neutralPercent=scales::percent(totalNeutral/mentionCount),
           negativePercent=scales::percent(totalNegative/mentionCount)) %>%
    dplyr::rename(verifiedCount=mentionCount)

  data <- brandseyer2::count_mentions(ac,
                             filter,
                             select="mentionCount,authorNameCount,totalOTS,totalEngagement,siteCount") %>%
    cbind(sentiment_stats) %>%
    dplyr::rename(Volume=mentionCount, Authors=authorNameCount, Sites=siteCount, OTS=totalOTS, Engagement=totalEngagement, "Verified Sample"=verifiedCount, Positive=totalPositive, Neutral=totalNeutral, Negative=totalNegative, "Positive %"=positivePercent, "Neutral %"=neutralPercent, "Negative %"=negativePercent) %>%
    tidyr::gather(Metric, Value)

  if (save) file = rstudioapi::selectFile(caption = "Save as",
                                          filter = "CSV Files (*.csv)",
                                          existing = FALSE)
  if (save && is.null(file)) {
    warn("Saving of file cancelled")
  }

  if (!is.null(file)) {
    data %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}
