% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/topics.R
\name{topics_metric}
\alias{topics_metric}
\title{Gets the Topics for a given filter}
\usage{
topics_metric(code, filter, file = NULL, save = FALSE,
  truncateAt = NULL, showParents = TRUE, showChildren = TRUE,
  forParent = NULL)
}
\arguments{
\item{code}{An account code}

\item{filter}{A filter for data}

\item{file}{An optional file name to save a CSV file to.}

\item{save}{Set to TRUE if you'd like a dialog file to choose where to save your CSV.}

\item{truncateAt}{Optional number of results - rest will become "Others". This takes the
top topics based on the volume of mentions from the site.}

\item{showParents}{Set this to FALSE if you don't want any parent topics included in the
results.}

\item{showChildren}{Set this to FALSE if you don't want any child topics included in the
results.}

\item{forParent}{An ID of a parent topic that you want data specifically for. Adds an extra
column of percentage values specifically against that parent.}
}
\value{
A tibble of your data
}
\description{
Returns topic data for a given filter. The filter must filter on the brand's topic_tree.
}
\details{
One thing to note is that your filter should contain a \emph{topic tree} id. This
is a tag ID that identifies the topics assigned to a particular brand. See
below for more details. Using the \code{showParents} and
\code{showChildren} parameters, its easy to only show parent and child topics, respectively.
It is also possible to show only a single parent and its children. See the \code{forParent} parameter.
Essentially, you should pass it the ID of the parent topic whose children you
are interested in.
}
\section{Finding topic tree IDs}{


The major difficulty in using this function is that your filter must contain a \emph{topic tree}
id. This is a tag ID that identifies the topics that have been assigned to the brand(s)
that you're querying.

There are two ways to find the ID, both using brandseyer2. The first is to ask for all root
brand information, like so:

\preformatted{
library(brandseyer2)
account("BEUB03AA") \%>\%
  root_brands(short = FALSE)
}

The column \code{topic_tree_id} will give the topic tree ID for the brand that you are interested in.

Another way is to ask for the topic trees in an account:

\preformatted{
library(brandseyer2)
account("BEUB03AA") \%>\%
  topic_trees()
}

This returns regular tag information (since topic trees are only tags).

Assuming the topic tree that you're interested in has an ID of 1001, and your
filter is "published inthelast month and relevancy isnt irrelevant", your new filter should be
"(published inthelast month and relevancy isnt irrelevant) and tag is 1001".
}

\examples{

\dontrun{
topics_metric("QUIR01BA", "published inthelast week and brand isorchildof 10006 and tag is 1001")
}
}
