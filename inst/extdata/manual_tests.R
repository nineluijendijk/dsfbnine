#Measlesdata
data("measlesdata")
dataSummarizer(measlesdata, groupBy = c("CountryName", "year"))

#illnessPlot
data_illness <- utils::read.csv(here::here("inst/extdata/datacovid.csv"))
illnessPlot(data_illness, countries = c("Netherlands", "Belgium", "France"),
           years = 2020:2022, parameter = cases)

#gotermAnalysis
DESeqDataSet <- readRDS(here::here("inst/extdata/DESeqDataSet"))
results_dge <- DESeq2::results(DESeq2::DESeq(DESeqDataSet))
results <- gotermAnalysis(results_dge)

#gotermPlot
gotermAnalysis_results <- readRDS(here::here("inst/extdata/gotermAnalysis_results"))
gotermPlot(gotermAnalysis_results,
           topamount = 5,
           plot_title = "Top upregulated GO-terms")
