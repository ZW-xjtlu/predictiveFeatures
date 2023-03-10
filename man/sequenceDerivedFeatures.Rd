% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sequenceDerivedFeatures.R
\name{sequenceDerivedFeatures}
\alias{sequenceDerivedFeatures}
\title{Extract sequence-derived predictive features from interval-based data}
\usage{
sequenceDerivedFeatures(
  x,
  sequence,
  mutation = NULL,
  encoding = c("onehot", "iRNA"),
  cnn = FALSE
)
}
\arguments{
\item{x}{A \link{GRanges} object for the genomic ranges to be annotated, the \code{width} of x must all be equal.}

\item{sequence}{A \link{BSgenome} or \link{XStringSet} object for the genome sequence.}

\item{mutation}{A \link{GRanges} object indicating the SNP ranges (must be single-based), 
a metadata column is required to annotate the changed nucleotide sequence.}

\item{encoding}{Can be one of the following:
\describe{
\item{\strong{onehot}}{From the 5' end to the 3'end of x, 
each nucleotide position is coded by 4 indicators/dummy variables, 
where each dummy variable indicates that the position is equal to the base "A", "T", "C", and "G", respectively.}

\item{\strong{iRNA}}{
Each nucleotide position is encoded by 4 variables, 
the first variable indicates that the nucleotide is purine (A or G), 
the second variable indicates that the nucleotide has an amino group (A or C), 
and the third variable indicates the formation of weak hydrogen bond (A or T), 
the fourth variable is calculated by the cumulative frequency of nucleotides from 
the leftmost position to the current position.
}
}}

\item{cnn}{Whether report in CNN format; default is \code{FALSE}.}
}
\value{
If \code{cnn == FALSE}, the returned object is a \code{data.frame} whose number of rows is the length of \code{x}, and the number of columns is 4 times the width of \code{x}.
The column types in the \code{data.frame} are all numeric.

When \code{cnn == TRUE}, the returned object is an \code{array} of n matrices corresponding to the feature vectors of each position in the sequence.

If \code{mutation} is provided, a list of 2 matrices/arrays of equal sizes will be returned, while the first is for the normal sequences, and
the 2nd is for the mutated sequences. The mapping between the matrix and the rows of mutation GRanges is labeled in the rownames.
}
\description{
A function to extract sequence features from the input \code{\link{GRanges}} object and the \code{\link{BSgenome}} object.
}
\details{
The function first extract DNA sequence within the genomic ranges defined by \code{x}. 
Then, the DNA strings are processed according to the selected sequence encoding method.
}
\examples{
library(BSgenome.Hsapiens.UCSC.hg19)

## Define the Granges to be annotated:
set.seed(01)

X <- GRanges(rep(c("chr1", "chr2"), c(15, 15)),
             IRanges(c(sample(11874:12127, 15), sample(38814:41527,15)), width=5),
             strand=Rle(c("+", "-"), c(15, 15)))
   
## Extract onehot encoded sequence features
seq_onehot <- sequenceDerivedFeatures(X, Hsapiens, encoding = "onehot")       
str(seq_onehot)                

## Extract iRNA encoded sequence features
seq_iRNA <- sequenceDerivedFeatures(X, Hsapiens, encoding = "iRNA")
str(seq_iRNA)

## Extract mutated features
SNP <- resize(X[c(10,15,3,6)], 1)
SNP$mutateTo <- c("A","C","G","C")
seq_mutation <- sequenceDerivedFeatures(X, Hsapiens, mutation = SNP)

rownames(seq_mutation[[1]]) #index for x
rownames(seq_mutation[[2]]) #index for mutation

}
\seealso{
\itemize{
\item{}{The \link{genomeDerivedFeatures} for extraction of genome-derived features.}
\item{}{The \link{topologyOnTranscripts} for calculation of the meta-tx topologies on transcripts of genes.}
}
}
