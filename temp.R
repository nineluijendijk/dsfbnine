library(DESeq2)
library("org.Hs.eg.db")


gotermAnalysis <- function(dge_results, L2FC = 1, padjusted = 0.01, ontologytype = "BP", pcutoff = 1, upregulated = TRUE) {
  if(upregulated == TRUE){
    regulated_genes <- dge_results %>% data.frame() %>%
      dplyr::filter(log2FoldChange > L2FC, padj < padjusted) %>% rownames()
  } else {
    regulated_genes <- dge_results %>% data.frame() %>%
      dplyr::filter(log2FoldChange < -L2FC, padj < padjusted) %>% rownames()
  }

  all_genes <- dge_results %>% data.frame() %>% rownames()
  test_object <- methods::new("GOHyperGParams",
                     geneIds = regulated_genes,
                     universeGeneIds = all_genes,
                     annotation = "org.Hs.eg.db",
                     ontology = ontologytype,
                     pvalueCutoff = pcutoff,
                     testDirection = "over")

  summary(GOstats::hyperGTest(test_object))
}



gotermAnalysis <- function(dge_results, L2FC = 1, padjusted = 0.01, ontologytype = "BP", pcutoff = 1, upregulated = TRUE) {
  if(!("GOstats" %in% (.packages()))){
    library(GOstats)
  }
  if(upregulated == TRUE){
    regulated_genes <- dge_results %>% data.frame() %>%
      dplyr::filter(log2FoldChange > L2FC, padj < padjusted) %>% rownames()
  } else {
    regulated_genes <- dge_results %>% data.frame() %>%
      dplyr::filter(log2FoldChange < -L2FC, padj < padjusted) %>% rownames()
  }

  all_genes <- dge_results %>% data.frame() %>% rownames()
  test_object <- methods::new("GOHyperGParams",
                              geneIds = regulated_genes,
                              universeGeneIds = all_genes,
                              annotation = "org.Hs.eg.db",
                              ontology = ontologytype,
                              pvalueCutoff = pcutoff,
                              testDirection = "over")

  summary(GOstats::hyperGTest(test_object))

}

library(tidyverse)
results_dge <- readRDS(here::here("inst/extdata/dge_results"))
ham <- gotermAnalysis(results_dge)
ham1 <- gotermAnalysis2(results_dge)

all.equal(ham, ham1)

gotermPlot_results <- gotermPlot(gotermAnalysis_results, topamount = 5, plot_title = "Top 10 enriched GO-terms")

class(gotermPlot_results)

gotermAnalysis_results %>% saveRDS(here("gotermAnalysis_results"))
gotermPlot_results %>% saveRDS(here("gotermPlot_results"))

a <- readRDS(here("gotermAnalysis_results"))
class(a)
?results
?count

gotermAnalysis_results <- readRDS(here("gotermAnalysis_results"))
identical(ham, gotermAnalysis_results)
class(gotermAnalysis_results)
class(ham)


?paste0

library(here)
library(tidyverse)

dataplot <- read.csv(here::here("inst/extdata/datacovid.csv"))

class(dataplot)

data_filtered <- data %>% filter(countriesAndTerritories %in% c("Spain"), year %in% 2020:2022, month %in% 1:12)

data_filtered <- mutate(data_filtered, "date" = paste(day, month, year, sep="/"))

data_filtered$date <- as.Date(data_filtered$date, format="%d/%m/%Y")


illnesPlot <- function(data, countries = "Spain", years = 2020:2022,  parameter = cases){
  string <- deparse(substitute(parameter))
  data_filtered <- data %>% dplyr::filter(countriesAndTerritories %in% countries, year %in% years)
  data_filtered <- dplyr::mutate(data_filtered, "date" = paste(day, month, year, sep="/"))
  data_filtered$date <- as.Date(data_filtered$date, format="%d/%m/%Y")
  ggplot2::ggplot(data_filtered,
                 ggplot2::aes(x = date, y = {{parameter}}, group = countriesAndTerritories,
                     color = countriesAndTerritories))+
    ggplot2::geom_line()+
    ggplot2::labs(title = paste("Number of newly reported COVID-19", string, "over time by country"),
                 y = paste("Number of COVID-19", string),
                 x = "Date",
                 color = "Country")+
    ggplot2::scale_x_date(date_breaks = "1 month", date_labels = "%d-%m-%y")+
    ggplot2::scale_y_continuous(labels = scales::label_comma(), limits = c(0, NA))+
    ggplot2::theme_minimal()+
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5, hjust = 1))
}


illnessPlot(dataplot, countries = c("Netherlands", "Belgium", "France"), years = 2020:2022, parameter = cases)

?axis.text.x

max(data_filtered[["deaths"]], na.rm = TRUE)

library(ggplot2)
?element_text
?aes
dataSummarizer <- function(data, groupBy = "CountryName"){
  data %>% dplyr::group_by_at(groupBy) %>%
    dplyr::summarize(total = sum(cases, na.rm = TRUE),
                     mean = mean(cases, na.rm = TRUE),
                     median = stats::median(cases, na.rm = TRUE),
                     standarddeviation = stats::sd(cases, na.rm = TRUE)) %>%
    dplyr::arrange(desc(mean))
}

dataSummarizer(measlesdata, groupBy = c("CountryName", "year"))

library(tidyverse)
data("measlesdata")
?mean
measlesdata
library(dplyr)











library(tidyverse)
library(readxl)
data2019 <- readxl::read_excel(here::here("data_raw/measlesdata_2019.xlsx"), na = ".")
data2018 <- readxl::read_excel(here::here("data_raw/measlesdata_2018.xlsx"))
datapopulation <- readxl::read_excel(here::here("data_raw/EU_population.xlsx"),
                                     sheet = 3, skip = 9, col_names = c("CountryName", "2018", "a", "2019", "b"))

datapopulation <-dplyr::select(datapopulation, -c("a", "b"))
datapopulation <- datapopulation[-c(32:38),]
datapopulation$`2018` <- as.double(datapopulation$`2018`)
datapopulation[datapopulation == "European Union - 28 countries (2013-2020)"] <- "EU/EEA"
datapopulation[datapopulation == "Germany (until 1990 former territory of the FRG)"] <- "Germany"
datapopulation[datapopulation == "Czechia"] <- "Czech Republic"
datapopulation <- tidyr::pivot_longer(data = datapopulation, cols = c(2:3),
                             names_to = "year",  values_to = "population")


data2018$year <- 2018
data2018 <- data2018 %>% tidyr::pivot_longer(cols = c(2:13), names_to = "month",  values_to = "cases")
data2018 <- tidyr::separate(data2018, month, into = c("year", "month"))

data2019$year <- 2019
data2019 <- data2019 %>% tidyr::pivot_longer(cols = c(2:13), names_to = "month",  values_to = "cases")
data2019 <- tidyr::separate(data2019, month, into = c("year", "month"))

datacases <- rbind(data2018, data2019)
measlesdata <- dplyr::inner_join(datacases, datapopulation, by = c("CountryName", "year"))

save(measlesdata, file = here("data/measlesdata.RData"))




gotermPlot <- function(goterm_results, padj_method = "BH", filter_from = 5, filter_to = 500, topamount = 10, plot_title) {
  goterm_results$padj <- stats::p.adjust(goterm_results$Pvalue, method = padj_method)
  goterm_results <- goterm_results %>% dplyr::filter(Count > filter_from) %>% dplyr::filter(Count < filter_to)
  goterm_results_top <- goterm_results[order(goterm_results$padj)[1:topamount],]
  goterm_results_top$Term <- factor(goterm_results_top$Term,
                                    levels = goterm_results_top$Term[
                                      order(goterm_results_top$padj, decreasing = TRUE)])

  goterm_results_top %>% data.frame() %>% ggplot2::ggplot(aes(x = Term, y = -log10(padj))) +
    ggplot2::geom_point() +
    ggplot2::coord_flip() +
    ggplot2::labs(title = plot_title,
                  x = "GO terms",
                  y = expression(-log[10](adjusted~italic(P)~value)))+
    ggplot2::theme_minimal()
}

?system.file


gotermAnalysis <- function (dge_results, L2FC = 1, padjusted = 0.01, ontologytype = "BP",
                            pcutoff = 1, upregulated = TRUE)
{
  if (upregulated == TRUE) {
    regulated_genes <- dge_results %>% data.frame() %>% dplyr::filter(log2FoldChange >
                                                                        L2FC, padj < padjusted) %>% rownames()
  }
  else {
    regulated_genes <- dge_results %>% data.frame() %>% dplyr::filter(log2FoldChange <
                                                                        -L2FC, padj < padjusted) %>% rownames()
  }
  all_genes <- dge_results %>% data.frame() %>% rownames()
  test_object <- methods::new("GOHyperGParams", geneIds = regulated_genes,
                              universeGeneIds = all_genes, annotation = "org.Hs.eg.db",
                              ontology = ontologytype, pvalueCutoff = pcutoff, testDirection = "over")
  summary(GOstats::hyperGTest(test_object))
}

library(dsfbnine)
measles <- data(measlesdata)
