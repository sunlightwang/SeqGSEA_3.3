\name{runSeqGSEA}
\alias{runSeqGSEA}
\title{
An all-in function that allows end users to apply SeqGSEA to their data with one step.
}
\description{
This function provides typical SeqGSEA analysis pipelines for end users to apply the SeqGSEA method in the 
easiest fashion. It assumes the pipelines start with exon reads counts, even for the DE-only analysis. 
Users should specify their file locations and a few parameters before running this pipeline. 

It allows DE-only analysis, which will skip the DS analysis portion, and it also allows users to 
try different weights in integrating DE and DS scores, which will save time in computing the DE and DS
scores. 

The function returns a list of SeqGSEA analysis results in the format of \code{\link{GSEAresultTable}}, and 
generates a few plots and writes a few files, whose name prefix can be specified. The output files will either 
be in PDF format or TXT format, and generated by \code{\link{plotGeneScore}}, \code{\link{writeScores}}, 
\code{\link{plotES}}, \code{\link{plotSig}}, \code{\link{plotSigGeneSet}}, and \code{\link{writeSigGeneSet}}.  
}
\usage{
runSeqGSEA(data.dir, case.pattern, ctrl.pattern, geneset.file, output.prefix, topGS=10, 
           geneID.type=c("gene.symbol", "ensembl"), nCores=1, perm.times=1000, seed=NULL, 
           minExonReadCount=5, integrationMethod=c("linear", "quadratic", "rank"), 
           DEweight=c(0.5), DEonly=FALSE, minGSsize=5, maxGSsize=1000, GSEA.WeightedType=1) 
}
\arguments{
  \item{data.dir}{a character vector, the path to your count data directory.}
  \item{case.pattern}{a character vector, the unique pattern in the file names of case samples. 
                      E.g, if file names starting with "SC", the pattern writes "^SC".}
  \item{ctrl.pattern}{a character vector, the unique pattern in the file names of control samples. }
  \item{geneset.file}{a character vector, the path to your gene set file. The gene set file must be in 
                      GMT format. Please refer to the link follows for details. 
                      http://www.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#GMT:_Gene_Matrix_Transposed_file_format_.28.2A.gmt.29}
  \item{output.prefix}{a character vector, the path with prefix for output files. }
  \item{topGS}{an integer, this number of top ranked gene sets will be output with details; if geneset.file contains less than this number of gene sets, all gene sets' result details will be output. Default: 10.}
  \item{geneID.type}{the gene ID type in geneset.file. Currently only support "gene.symbol" and "ensembl". Default: gene.symbol.}
  \item{nCores}{an integer. The number of cores for running SeqGSEA. Default: 1}
  \item{perm.times}{an integer. The number of times for permutation, which will be used for normalizing DE and DS scores and for GSEA significance analysis.
                    Recommended values are greater than 1000. Default: 1000.}
  \item{seed}{an integer or NULL, used for setting the seeds to generate random numbers. The same seed will guarantee the same analysis results given by SeqGSEA. Default: NULL.}
  \item{minExonReadCount}{an integer. An exon with total read count across all samples less than this number will be marked as untestable and be excluded in SeqGSEA analysis. Default: 5.}
  \item{integrationMethod}{one of the three integration methods for DE and DS score integration: linear, quadratic, or rank. Default: linear.}
  \item{DEweight}{a real number between 0 and 1 OR a vector of those. Each number is the DE weight in DE and DS integration. If using a vector of real numbers, SeqGSEA will run with each of them individually. Default: 0.5.}
  \item{DEonly}{logical, whether to run SeqGSEA only considering DE. Default: FALSE}
  \item{minGSsize}{an integer. The minimum gene set size: gene sets with genes less than this number will be skipped. Default: 5.}
  \item{maxGSsize}{an integer. The maximum gene set size: gene sets with genes greater than this number will be skipped. Default: 1000.}
  \item{GSEA.WeightedType}{the weight type of the main GSEA algorithm, can be 0 (unweighted = Kolmogorov-Smirnov), 1 (weighted), and 2 (over-weighted). Default: 1. It is recommended not to change it. }
}
\value{
A list of SeqGSEA analysis results in the format of \code{\link{GSEAresultTable}}, which allows users for meta-analysis. 
}
\references{
Xi Wang and Murray J. Cairns (2013). Gene Set Enrichment Analysis of RNA-Seq Data: Integrating Differential Expression and Splicing. BMC Bioinformatics, 14(Suppl 5):S16.
}
\author{
Xi Wang, xi.wang@mdc-berlin.de
}
\seealso{
\code{\link{GSEAresultTable}},
\code{\link{geneScore}},
\code{\link{GSEnrichAnalyze}}
}
\examples{
### Initialization ###
# input file location and pattern
data.dir <- system.file("extdata", package="SeqGSEA", mustWork=TRUE)
case.pattern <- "^SC" # file name starting with "SC"
ctrl.pattern <- "^SN" # file name starting with "SN"
# gene set file and type
geneset.file <- system.file("extdata", "gs_symb.txt",
                            package="SeqGSEA", mustWork=TRUE)
geneID.type <- "ensembl"
# output file prefix
output.prefix <- "SeqGSEAexample"
# analysis parameters
nCores <- 1
perm.times <- 10
DEonly <- FALSE
DEweight <- c(0.2, 0.5, 0.8) # a vector for different weights
integrationMethod <- "linear"

### one step SeqGSEA running ###
# Caution: if running the following command line, it will generate many files in your working directory
runSeqGSEA(data.dir=data.dir, case.pattern=case.pattern, ctrl.pattern=ctrl.pattern, 
           geneset.file=geneset.file, geneID.type=geneID.type, output.prefix=output.prefix,
           nCores=nCores, perm.times=perm.times, integrationMethod=integrationMethod,
           DEonly=DEonly, DEweight=DEweight)
}
