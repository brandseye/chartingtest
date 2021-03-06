% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/race.R
\name{race_metric}
\alias{race_metric}
\title{Fetch race data}
\usage{
race_metric(code, filter, file = NULL, save = FALSE)
}
\arguments{
\item{code}{An account code}

\item{filter}{A filter for the data}

\item{file}{An optional file name to save to}

\item{save}{Pass TRUE if you would like to see a save file dialog}
}
\value{
A tibble of race data
}
\description{
Fetch race data
}
\examples{
\dontrun{
race_metric("QUIR01BA", "published inthelast week  and brand isorchildof 10006")
}
}
