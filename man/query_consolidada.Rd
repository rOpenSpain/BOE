% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/queries.R
\name{query_consolidada}
\alias{query_consolidada}
\title{Build a query for the webpage}
\usage{
query_consolidada(cve)
}
\arguments{
\item{cve}{The CVE of the document you want.}
}
\value{
A query url.
}
\description{
Look for the consolidated law online
}
\examples{
cve <- disposicion_cve("2017", "117")
query_consolidada(cve)
}
