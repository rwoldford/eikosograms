% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eikos_probs.R
\name{eikos_x_probs}
\alias{eikos_x_probs}
\title{Create grob with eikosogram x-axis probabilities}
\usage{
eikos_x_probs(data, xprobs = NULL, xprobs_size = 8, margin = unit(2,
  "points"), rotate = TRUE)
}
\arguments{
\item{data}{data frame from eikos_data object}

\item{xprobs}{vector of probabilities to be shown. NULL if they should be calculated from the data.}

\item{xprobs_size}{font size of labels for horizontal probabilities (in points)}

\item{margin}{unit specifying margin between y axis and eikosogram}

\item{rotate}{logical, whether probabilities should be rotated vertically.}
}
\value{
textGrob with x-axis probabilities.
}
\description{
Creates x axis grob to be placed on eikosogram. Called by eikos functions.
}
