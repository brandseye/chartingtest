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

#' Pulls breakdown of volume by keyword
#'
#' @param code An account code
#' @param filter A filter for data
#' @param file   An optional file name to save a CSV file to
#' @param save   Set to TRUE if you'd like a dialog file to choose where to save your CSV
#' @param exclude A character vector of terms you want to exclude
#'
#' @return Return a list of words and volume of mentions
#' @export
#'
#' @examples
#'
#' wordcloud_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006")
#'
wordcloud_metric <- function(code, filter, exclude = NULL, save = FALSE, file = NULL) {

  # For devtools::check
  extractWord <- NULL; mentionCount <- NULL;

  ac <- account(code)
  data <- count_mentions(ac, filter, groupBy = "extractWord") %>%
    filter(is.na(as.numeric(extractWord))) %>%
    transmute(Word=extractWord, Mentions=mentionCount)

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
