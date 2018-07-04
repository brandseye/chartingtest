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


#' Checks whether authors from current filter appeared in a previous filter
#'
#' @param code The account code to use
#' @param previousFilter Filter for the time period you want to compare your authors against
#' @param currentFilter Filter for the current time period whose authors you want to check
#' @param file An optional file name to save a CSV file to
#' @param save Set to TRUE if you'd like a dialog file to choose where to save your CSV
#'
#' @return A tibble of your data
#' @export
#'

returning_authors <- function(code, previousFilter, currentFilter, file = NULL, save = FALSE) {

  # For devtools::check
  authorHandle <- NULL; authorId <- NULL; authorName <- NULL; authorStatus <- NULL; percentage <- NULL;

  ac <- account(code)

  original_authors <- count_mentions(ac, previousFilter, groupBy = c(authorId, authorHandle, authorName)) %>%
    select(authorId, authorHandle, authorName)

  data <- count_mentions(ac, currentFilter, groupBy = c(authorId, authorHandle, authorName)) %>%
    select(authorId, authorHandle, authorName) %>%
    mutate(authorStatus=purrr::map_chr(authorId, function(x) {
      if (x %in% original_authors$authorId) "returning"
      else "new"
    })
    )

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


#' Returns a breakdown of new vs returning authors
#'
#' @param code The account code to use
#' @param previousFilter Filter for the time period you want to compare your authors against
#' @param currentFilter Filter for the current time period whose authors you want to check
#' @param file An optional file name to save a CSV file to
#' @param save Set to TRUE if you'd like a dialog file to choose where to save your CSV
#'
#' @return A tibble of your data
#' @export
#'
#' @examples
#'
#' returning_authors_metric("QUIR01BA",
#' "published after '2018/05/01' and published before '2018/06/01' and brand isorchildof 10006",
#' "published after '2018/06/01' and published before '2018/07/01' and brand isorchildof 10006")

returning_authors_metric <- function(code, previousFilter, currentFilter, file = NULL, save = FALSE) {

  # For devtools::check
  authorHandle <- NULL; authorId <- NULL; authorName <- NULL; authorStatus <- NULL; percentage <- NULL;

  data <- returning_authors(code, previousFilter, currentFilter) %>%
    group_by(authorStatus) %>%
    summarise(count=n()) %>%
    mutate(percentage=count/sum(count))

  if (save) file = rstudioapi::selectFile(caption = "Save as",
                                          filter = "CSV Files (*.csv)",
                                          existing = FALSE)
  if (save && is.null(file)) {
    warn("Saving of file cancelled")
  }

  if (!is.null(file)) {
    data %>%
      mutate(percentage=scales::percent(percentage)) %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}
