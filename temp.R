library(DESeq2)
library("org.Hs.eg.db")

resultsdge <- readRDS(here("dge_results"))

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

gotermAnalysis_results <- gotermAnalysis(resultsdge)
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
