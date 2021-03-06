% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rankSpacers.R
\name{rankSpacers}
\alias{rankSpacers}
\alias{filterSpacers}
\alias{validCriteria}
\title{Filter and rank spacers}
\usage{
filterSpacers(
  guideSet,
  criteria,
  txId = NULL,
  geneId = NULL,
  isoformAggFun = c("max", "mean", "min")
)

rankSpacers(
  guideSet,
  criteria,
  txId = NULL,
  geneId = NULL,
  isoformAggFun = c("max", "mean", "min")
)

validCriteria(guideSet)
}
\arguments{
\item{guideSet}{A \linkS4class{GuideSet} object.}

\item{criteria}{A named list of values to filter or rank spacers
List names must match names in \code{mcols(guideSet)} or
column names of annotation list-columns, such as \code{geneAnnotation}.
Duplicate names are permitted. See Details.}

\item{txId}{String specifying transcript ID. If \code{criteria} contains
gene-level criteria, either \code{txId} or \code{geneId} must 
be provided. See Details for gene-level criteria.}

\item{geneId}{String specifying gene ID. If \code{criteria} contains
gene-level criteria, either \code{txId} or \code{geneId} must 
be provided. See Details for gene-level criteria.}

\item{isoformAggFun}{String specifying the function name to be used 
to aggregate gene-level data for gene-level \code{criteria} parameters
when \code{is.null(txId)} and \code{!is.null(geneId)}.
See Details for gene-level criteria.}
}
\value{
\code{filterSpacers} - a \linkS4class{GuideSet} object filtered 
    by the values in \code{criteria}.

\code{rankSpacers} - a \linkS4class{GuideSet} object sorted by bins
    defined in \code{criteria}. A \code{rankings} list-column will also be
    stored in \code{mcols(GuideSet)}, which includes guide bin values for
    each element in \code{criteria}, and a \code{rank} column aggregated
    from all possible bin value combinations.
}
\description{
Functions for filtering or ranking spacers within a
    \linkS4class{GuideSet} object according to supplied criteria.
}
\details{
Use \code{validCriteria(guideSet)} for information on expected values
    for \code{criteria}, \code{txId}, and \code{geneId} arguments. There
    are four parameters:
    
    \itemize{
        \item \strong{attribute} — acceptable names for \code{criteria},
        which correspond to the column names in \code{mcols} or list-columns
        of \code{guideSet}.
        \item \strong{valueType} — type of values used to divide data for
        the specified attribute. There are four types, with specific
        requirements:
        \itemize{
            \item \bold{logical}: TRUE or FALSE. Indicates a preference for
            which value to retain (\code{filterSpacers}) or assign a higher
            rank (\code{rankSpacers}).
            \item \bold{asc}: a numeric vector in strictly ascending order
            (no duplicates). Sets binning intervals that are closed on the
            right.
            \item \bold{desc}: a numeric vector in strictly descending order
            (no duplicates). Sets binning intervals that are closed on the
            left.
            \item \bold{ranged}: a numeric vector of length 2 with values
            in the range 0-100 (duplicates permitted). Sets an inclusive
            percentile range for spacers to retain (\code{filterSpacers})
            or assign a higher rank (\code{rankSpacers}).
        }
        \item \strong{takesTxId} — Whether the attribute uses \code{txId}
        to obtain values for filtering or ranking.
        \item \strong{takesGeneId} — Whether the attribute uses
        \code{geneId} to obtain values for filtering or ranking.
    }
    
    If \code{criteria} contains an attribute for which only one of
    \code{takesTxId} or \code{takesGeneId} is \code{TRUE} then the
    corresponding must be provided. For some attributes, either ID is
    acceptable. In this case, the \code{txId} will be used if supplied,
    regardless of whether \code{geneId} is also supplied However, if
    \code{geneId} is supplied and \code{txId} is not, the values for that
    attribute will obtained via the \code{geneId} and aggregated according
    to \code{isoformAggFun}.
    
    \code{filterSpacers} filters for spacers meeting all supplied criteria,
    or, those having all attributes in \code{criteria} in the first (best)
    bin. Consequently, \code{asc} and \code{desc} values in \code{criteria}
    passed to \code{filterSpacers} need only define the limits of the first
    bin.
    
    \code{rankSpacers} assigns ranks to and sorts spacers according to
    \code{criteria}, with the order of attributes in \code{criteria}
    determining ranking priority. Attributes in \code{criteria} may be
    used multiple times.
}
\examples{

data(guideSetExampleFullAnnotation)
guides <- guideSetExampleFullAnnotation
guides <- guides[1:2]

# check guide attributes available for filtering and ranking
validCriteria(guides)

filter_criteria <- list(
    EcoRI = FALSE,
    KpnI = FALSE,
    polyT = FALSE
)
guides <- filterSpacers(guides, filter_criteria)
  
rank_criteria <- list(
    isCommonCodingExon = TRUE,
    score_deephf = c(0.7, 0.6, 0.5),
    score_azimuth = c(0.7, 0.6, 0.5)
)
guides <- rankSpacers(guides,
                      rank_criteria,
                      geneId="ENSG00000120645")

}
\author{
Luke Hoberecht
}
