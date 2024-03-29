% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/retrieve.R
\name{retrieve_sumario}
\alias{retrieve_sumario}
\title{Retrieve the \emph{sumario}}
\usage{
retrieve_sumario(date, journal = "BOE")
}
\arguments{
\item{date}{A Date of the \emph{sumario}.}

\item{journal}{Either BOE or BORME.}
}
\value{
A data.frame with one line for each publication.
}
\description{
Obtain a \emph{sumario} and tidy it in a table.
}
\examples{
\donttest{retrieve_sumario(last_date_boe())}
}
\seealso{
\link{tidy_sumario} to learn about the format of the output

Other functions to retrieve documents: 
\code{\link{retrieve_document}()}
}
\concept{functions to retrieve documents}
