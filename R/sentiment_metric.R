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

#' Returns the data for sentiment chart
#'
#' @param code An account code
#' @param filter A filter for data
#' @param file   An optional file name to save a CSV file to.
#' @param save   Set to TRUE if you'd like a dialog file to choose where to save your CSV.
#'
#' @return A tibble of your data
#' @export
#'
#' @examples sentiment_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006")
#'

sentiment_metric <- function(code, filter, file = NULL, save = FALSE) {

  # For devtools::check
  Percentage <- NULL; Sentiment <- NULL; negativeCount <- NULL; neutralCount <- NULL; positiveCount <- NULL;

  data <- brandseyer::account_count(code, filter, include="sentiment-count") %>%
    transmute("Negative"=scales::percent(negativeCount/count),
              "Neutral"=scales::percent(neutralCount/count),
              "Positive"=scales::percent(positiveCount/count)) %>%
    tidyr::gather(Sentiment, Percentage)

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

#' Plot the sentiment chart
#'
#' @param code An account code
#' @param filter A filter for data
#'
#' @export
#'
#' @examples
#'
#' plot_sentiment_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006")

plot_sentiment_metric <- function(code, filter) {
  # ac <- account(code)

  # For devtools::check
  Percentage <- NULL; Sentiment <- NULL; negativeCount <- NULL; neutralCount <- NULL; positiveCount <- NULL; value <- NULL;

  brandseyer::account_count(code, filter, include="sentiment-count") %>%
    dplyr::transmute("Positive"=positiveCount/count, "Neutral"=neutralCount/count, "Negative"=negativeCount/count) %>%
    tidyr::gather(Sentiment, value) %>%
    ggplot(aes(x=Sentiment, y=value, fill=Sentiment)) +
    geom_bar(stat="identity") +
    scale_fill_manual(values=c("Negative"="#ee2737", "Neutral"=LIGHT_GREY, "Positive"="#00b0b9"), name="Sentiment") +
    scale_y_continuous(expand=c(0,0), labels=scales::percent, limits = c(0, 1)) +
    geom_text(aes(label=scales::percent(value)), vjust=-0.5, family="Open Sans Light") +
    theme_brandseye() +
    theme(legend.position = "none") +
    labs(title="Sentiment breakdown", x="Sentiment", y="Percentage of mentions")
}

