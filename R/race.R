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


#' Fetch race data
#'
#' @param code   An account code
#' @param filter A filter for the data
#' @param file   An optional file name to save to
#' @param save   Pass TRUE if you would like to see a save file dialog
#'
#' @return A tibble of race data
#' @export
#'
#' @examples
#' \dontrun{
#' race_metric("QUIR01BA", "published inthelast week  and brand isorchildof 10006")
#' }
race_metric <- function(code, filter, file = NULL, save = FALSE) {
  # for devtools::check
  race <- NULL; race.id <- NULL; mentionCount <- NULL; label <- NULL;
  engagement <- NULL; totalEngagement <- NULL; totalOTS <- NULL; totalSentiment <- NULL;
  netSentiment <- NULL; percentage <- NULL; netSentimentPercent <- NULL;
  . <- NULL;

  data <- account(code) %>%
    count_mentions(filter, groupBy = race, select = c(mentionCount, totalOTS, engagement, totalSentiment)) %>%
    mutate(label = purrr::map_chr(race, ~(if (is.null(.x)) "Unknown" else .x$label))) %>%
    select(-race) %>%
    rename(race = race.id, count = mentionCount,
           ots = totalOTS, engagement = totalEngagement, netSentiment = totalSentiment) %>%
    mutate(percentage = (if (sum(count, na.rm = TRUE) == 0) 0 else count / sum(count, na.rm = TRUE)),
           netSentimentPercent = (if (sum(count, na.rm = TRUE) == 0) 0 else netSentiment / sum(count, na.rm = TRUE))) %>%
    select(race, label, count, everything())

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
      tidyr::replace_na(list(race = "UNKNOWN")) %>%
      replace(is.na(.), "0") %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}
