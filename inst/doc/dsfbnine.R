## ----setuppackage, message=FALSE, results='hide', warning=FALSE---------------
devtools::install_github("nineluijendijk/dsfbnine")
library(dsfbnine)

## ----measlesexample-----------------------------------------------------------
measlesdata$cases %>% head(n = 20)

## ----dataSummarizerexample----------------------------------------------------
dataSummarizer(measlesdata, groupBy = c("CountryName", "year")) %>% head(n = 10)

## ----illnessPlotexample, fig.height = 5, fig.width = 7.2, fig.cap="Example illness plot."----
coviddata <- read.csv(here::here("inst/extdata/datacovid.csv")) #load the data
illnessPlot(coviddata, countries = c("Netherlands", "Belgium", "France"), years = 2020:2022, parameter = cases)

## ----fastaImporterexample-----------------------------------------------------
dna <- fastaImporter(here::here("inst/extdata/GenBankIDs2.txt"))
dna

## ----gotermAnalysisexample, eval=FALSE----------------------------------------
#  DESeqresults <- readRDS(here::here("inst/extdata/dge_results")) #load the data object of class "DESeqResults"
#  
#  gotermAnalysis_results <- gotermAnalysis(DESeqresults)

## ----gotermPlotexample, fig.height = 5, fig.width = 7.2, fig.cap="Example GO-term plot."----
gotermAnalysis_results <- readRDS(here::here("inst/extdata/gotermAnalysis_results"))

gotermPlot(gotermAnalysis_results, topamount = 10, plot_title = "Top 10 upregulated GO-terms")

