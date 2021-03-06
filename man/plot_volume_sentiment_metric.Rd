% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/volume-sentiment.R
\name{plot_volume_sentiment_metric}
\alias{plot_volume_sentiment_metric}
\title{Plots volume overlayed with sentiment.}
\usage{
plot_volume_sentiment_metric(account, filter, group = "day")
}
\arguments{
\item{account}{An account code}

\item{filter}{A filter for data}

\item{group}{A string indicating how you want your data grouped}
}
\value{
the ggplot object
}
\description{
Plots volume overlayed with sentiment.
}
\examples{

plot_volume_sentiment_metric("QUIR01BA", "published inthelast week  and brand isorchildof 10006")
}
