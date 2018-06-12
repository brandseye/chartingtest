#' Returns the data for creating a volume/sentiment
#'
#' @param code   The account code to use
#' @param filter The filter for the data.
#' @param group  An optional string to group data by. Can be "day", "week", "month"
#' @param file   An optional file name to save a CSV file to.
#'
#' @return A tibble of your data
#' @export
volume_sentiment <- function(code, filter, group = "day", file = NULL) {
  assert_that(is.string(code))
  assert_that(is.string(filter))
  assert_that(group %in% c("day", "week", "month"))
  assert_that(is.null(file) || is.string(file), msg = "File name must be a string")

  # For devtools::check
  published <- NULL; positiveCount <- NULL; negativeCount <- NULL;

  data <- brandseyer::account_count(code, filter = filter,
                                    groupby = glue("published[{group}]"),
                                    include="sentiment-count") %>%
    dplyr::mutate(net = positiveCount - negativeCount,
                  published = lubridate::force_tz(published, brandseyer::account_timezone(code)))

  if (!is.null(file)) {
    data %>%
      dplyr::mutate(published = format(published, "%F %R")) %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}
