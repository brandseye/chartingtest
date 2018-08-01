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
#' Returns topic data fora given filter. The filter must filter on the brand's topic_tree.
#'
#' One thing to note is that your filter should contain a _topic tree_ id. This
#' is a tag ID that identifies the topics assigned to a particular brand. See
#' below for more details.
#'
#' Topic data in various ways related to topics. Using the `showParents` and
#' `showChildren` parameters, its easy to only show parent and child topics, respectively.
#'
#' It is also possible to show only a single parent and its children. See the `forParent` parameter.
#' Essentially, you should pass it the ID of the parent topic whose children you
#' are interested in.
#'
#' @section Finding topic tree IDs:
#'
#' The major difficulty in using this function is that your filter must contain a _topic tree_
#' id. This is a tag ID that identifies the topics that have been assigned to the brand(s)
#' that you're querying.
#'
#' There are two ways to find the ID, both using brandseyer2. The first is to ask for all root
#' brand information, like so:
#'
#' \preformatted{
#' library(brandseyer2)
#' account("BEUB03AA") \%>\%
#'   root_brands(short = FALSE)
#' }
#'
#' The column `topic_tree_id` will give the topic tree ID for the brand that you are interested in.
#'
#' Another way is to ask for the topic trees in an account:
#'
#' \preformatted{
#' library(brandseyer2)
#' account("BEUB03AA") \%>\%
#'   topic_trees()
#' }
#'
#' This returns regular tag information (since topic trees are only tags).
#'
#' Assuming the topic tree that you're interested in has an ID of 1001, and your
#' filter is "published inthelast month and relevancy isnt irrelevant", your new filter should be
#' "(published inthelast month and relevancy isnt irrelevant) and tag is 1001".
#'
#' @param code An account code
#' @param filter A filter for data
#' @param file   An optional file name to save a CSV file to.
#' @param save   Set to TRUE if you'd like a dialog file to choose where to save your CSV.
#' @param truncateAt Optional number of results - rest will become "Others". This takes the
#'                   top topics based on the volume of mentions from the site.
#' @param showParents Set this to FALSE if you don't want any parent topics included in the
#'                    results.
#' @param showChildren Set this to FALSE if you don't want any child topics included in the
#'                    results.
#' @param forParent An ID of a parent topic that you want data specifically for. Adds an extra
#'                  column of percentage values specifically against that parent.
#'
#' @return A tibble of your data
#' @export
#'
#' @examples
#'
#' \dontrun{
#' topics_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006 and tag is 1001")
#' }


topics_metric <- function(code, filter, file = NULL,
                          save = FALSE, truncateAt = NULL,
                          showParents = TRUE,
                          showChildren = TRUE,
                          forParent = NULL) {
  assert_that(is.string(code))
  assert_that(is.string(filter))
  assert_that(is.null(file) || is.string(file), msg = "File name must be a string")
  assert_that(is.null(forParent) || assertthat::is.number(forParent),
              msg = "`forParent` must be a single integer")

  if (!showParents && !showChildren) {
    error("showParents and showChildren are both set to FALSE, so no data will be returned")
  }

  # For devtools::check
  engagement <- NULL; is_parent <- NULL; mentionCount <- NULL; parentPercentage <- NULL;
  tag <- NULL; tag.id <- NULL; tag.name <- NULL; percentage <- NULL; namespace <- NULL;
  totalEngagement <- NULL; totalOTS <- NULL; totalSentiment <- NULL; . <- NULL;
  totalPositive <- NULL; totalNegative <- NULL; totalNeutral <- NULL;
  ots <- NULL; netSentiment <- NULL; positivePercent <- NULL; negativePercent <- NULL;
  neutralPercent <- NULL; parentNegPercent <- NULL; parentNeutPercent <- NULL;
  parentPosPercent <- NULL;

  ac <- account(code)

  data <- ac %>%
    count_mentions(filter,
                   groupBy = tag,
                   tagNamespace = "topic",
                   select = c(mentionCount, engagement, totalSentiment,
                              totalOTS, totalPositive, totalNegative, totalNeutral)) %>%
    mutate(namespace = purrr::map_chr(tag, ~ .x[[1, "namespace"]]))

  trees <- data %>% dplyr::filter(namespace == "topic_tree")
  if (nrow(trees) == 0) {
    rlang::warn("No topic tree used in the filter for `topic_metric`. Unable to calculate percentages.")
  }

  if (nrow(trees) > 1) {
    rlang::warn("Multiple topic trees returned for `topic_metric`. Unsure which to use. A possible fix is to use a more exact filter. Unable to calculate percentages.")
  }

  data %<>% filter(namespace == "topic")
  parent_tree <- NULL

  if (nrow(trees) == 1) {
    message("1 tree present")
    parent_tree <- trees[[1, "tag.id"]]
    mentions <- trees[[1, "mentionCount"]]

    data %<>%
      mutate(percentage=mentionCount/mentions) %>%
      select(-namespace)
  } else {
    data %<>%
      mutate(percentage = NA) %>%
      select(-namespace)
  }

  if (!is.null(truncateAt)) {
    assert_that(is.number(truncateAt))
    top <- data %>% top_n(n = truncateAt, wt=mentionCount)
    others <- data %>%
      top_n(n=-(nrow(.)-truncateAt), wt=mentionCount) %$%
      tibble(tag.id=as.integer(0),
             tag.name = "Others",
             mentionCount = sum(mentionCount, na.rm = TRUE),
             totalEngagement = sum(totalEngagement, na.rm = TRUE),
             totalSentiment = sum(totalSentiment, na.rm = TRUE),
             totalPositive = sum(totalPositive, na.rm = TRUE),
             totalNegative = sum(totalNegative, na.rm = TRUE),
             totalNeutral = sum(totalNeutral, na.rm = TRUE),
             totalOTS = sum(totalOTS, na.rm = TRUE),
             percentage = sum(percentage, na.rm=TRUE))
    data <- bind_rows(top, others)
  }

  ac_topics <- NULL
  if (is.null(parent_tree)) {
    message("No parent")
    ac_topics <- ac %>% topics() %>% mutate(parent = NA)
  } else {
    message("has parent")
    ac_topics <- ac %>%
      tags() %>%
      with_tag_parents(parent_tree) %>%
      dplyr::filter(namespace == "topic")
  }

  data %<>%
    rename(id = tag.id,
           topic = tag.name,
           count = mentionCount,
           engagement = totalEngagement,
           netSentiment = totalSentiment,
           ots = totalOTS) %>%
    mutate(positivePercent = ifelse(count == 0, 0, totalPositive / count),
           negativePercent = ifelse(count == 0, 0, totalNegative / count),
           neutralPercent = ifelse(count == 0, 0, totalPositive / count)) %>%
    select(id, topic, count, percentage, engagement, ots,
           netSentiment, totalPositive, positivePercent, totalNegative, negativePercent,
           totalNeutral, neutralPercent, everything()) %>%
    tidyr::replace_na(list(count = 0, engagement = 0, netSentiment = 0, ots = 0)) %>%
    dplyr::left_join(ac_topics %>% select(id, is_parent, parent), by = c("id" = "id"))

  if (!is.null(forParent)) {
    topic <- ac_topics %>% filter(id == forParent)
    if (nrow(topic) == 0) error("No topic found for topic id ", forParent)
    tname <- topic %>% select("name") %>% pull()
    if (topic %>% filter(is_parent) %>% nrow() == 0) error("Topic is not a parent topic")
    done("Found parent topic '", tname, "'")
    children <- topic %>% purrr::pluck("children", 1)
    parent <- data %>% dplyr::filter(id == forParent)

    data %<>%
      filter(id %in% c(forParent, children))

    if (nrow(parent) == 1) {
      parent_count <- parent %>% purrr::pluck("count", 1)
      data %<>%
        mutate(parentPercentage = count / parent_count,
               parentPosPercent = totalPositive / parent_count,
               parentNegPercent = totalNegative / parent_count,
               parentNeutPercent = totalNeutral / parent_count)
    }
  }


  if (!showParents) {
    data %<>%
      filter(is_parent == FALSE)
  }

  if (!showChildren) {
    data %<>%
      filter(is_parent == TRUE)
  }

  data %<>% select(-tag, -is_parent)

  if (save) file = rstudioapi::selectFile(caption = "Save as",
                                          filter = "CSV Files (*.csv)",
                                          existing = FALSE)
  if (save && is.null(file)) {
    warn("Saving of file cancelled")
  }

  if (!is.null(file)) {
    write <- data %>%
      mutate(percentage=scales::percent(percentage))

    if ('parentPercentage' %in% names(write)) {
      write %<>%
        mutate(parentPercentage = scales::percent(parentPercentage),
               parentPosPercent = scales::percent(parentPosPercent),
               parentNegPercent = scales::percent(parentNegPercent),
               parentNeutPercent = scales::percent(parentNeutPercent))
    }

    write %>%
      readr::write_excel_csv(file, na = "")
    done(glue("Written your CSV to {file}"))
  }

  data
}
