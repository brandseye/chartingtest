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


#' Fetch gender data
#'
#' @param code   An account code
#' @param filter A filter for the data
#' @param file   An optional file name to save to
#' @param save   Pass TRUE if you would like to see a save file dialog
#'
#' @return A tibble of gender data
#' @export
#'
#' @examples
#' gender_metric("QUIR01BA", "published inthelast week  and brand isorchildof 10006")
gender_metric <- function(code, filter, file = NULL, save = FALSE) {
  # for devtools::check
  gender <- NULL; gender.id <- NULL; mentionCount <- NULL;

  data <- account(code) %>%
    count_mentions(filter, groupBy = gender) %>%
    select(-gender) %>%
    rename(gender = gender.id, count = mentionCount) %>%
    select(gender, count)

  if (save) file = rstudioapi::selectFile(caption = "Save as",
                                          filter = "CSV Files (*.csv)",
                                          existing = FALSE)

  if (save && is.null(file)) {
    warn("Saving of file cancelled")
  }

  if (!is.null(file)) {
    data %>%
      tidyr::replace_na(list(gender = "Unknown")) %>%
      mutate(gender = stringr::str_to_title(gender)) %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}
