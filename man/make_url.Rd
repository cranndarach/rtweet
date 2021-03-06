% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/TWIT.R
\name{make_url}
\alias{make_url}
\title{make_url}
\usage{
make_url(restapi = TRUE, query, param = NULL)
}
\arguments{
\item{restapi}{logical Default \code{restapi = TRUE}
indicates the provided URL components should be
specify Twitter's REST API. Set this to FALSE if you wish
to make a request URL designed for Twitter's streaming api.}

\item{query}{Twitter's subsetting/topic identifiers.
Although the httr package refers to this as "path",
query is used here to maintain consistency with
Twitter API's excellent documentation.}

\item{param}{Additional parameters (arguments) passed
along. If none, NULL (default).}
}
\value{
URL used in httr call.
}
\description{
make_url
}
\keyword{internal}

