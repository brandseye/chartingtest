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

#' Gets the Topics for a given filter
#'
#' @param code An account code
#' @param filter A filter for data
#' @param file   An optional file name to save a CSV file to.
#' @param save   Set to TRUE if you'd like a dialog file to choose where to save your CSV.
#' @param truncateAt Optional number of results - rest will become "Others". This takes the
#'                   top sites based on the volume of mentions from the site.
#' @param showParents Set this to FALSE if you don't want any parent topics included in the
#'                    results.
#' @param showChildren Set this to FALSE if you don't want any child topics included in the
#'                    results.
#'
#' @return A tibble of your data
#' @export
#'
#' @examples
#'
#' \dontrun{
#' topics_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006")
#' }


topics_metric <- function(code, filter, file = NULL,
                          save = FALSE, truncateAt = NULL,
                          showParents = TRUE,
                          showChildren = TRUE) {

  if (!showParents && !showChildren) {
    error("showParents and showChildren are both set to FALSE, so no data will be returned")
  }

  # For devtools::check
  engagement <- NULL; is_parent <- NULL; mentionCount <- NULL;
  tag <- NULL; tag.id <- NULL; tag.name <- NULL;
  totalEngagement <- NULL; totalOTS <- NULL; totalSentiment <- NULL; . <- NULL;

  ac <- account(code)

  data <- ac %>%
    count_mentions(filter,
                   groupBy = tag,
                   tagNamespace = "topic",
                   select = c(mentionCount, engagement, totalSentiment, totalOTS))

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
    rename(id = tag.id,
           topic = tag.name,
           count = mentionCount,
           engagement = totalEngagement,
           netSentiment = totalSentiment,
           ots = totalOTS) %>%
    dplyr::left_join(ac %>% topics() %>% select(id, is_parent))

  if (!showParents) {
    data %<>%
      filter(is_parent == FALSE)
  }

  if (!showChildren) {
    data %<>%
      filter(is_parent == TRUE)
  }

  data %<>% select(-tag, is_parent)

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
