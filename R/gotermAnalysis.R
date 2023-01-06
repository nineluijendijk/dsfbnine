#' Perform a GO-term enrichment analysis
#'
#' @param dge_results Object of class "DESeqResults".
#' @param L2FC Numeric value of the Log2FoldChange to determine what genes are differently regulated.
#' @param padjusted Numeric value of the adjusted p-value to determine what genes are differently regulated.
#' @param ontologytype Type of ontology to search for. Options: "BP", "CC", "MF".
#' @param pcutoff Numeric value of what p-values to filter by.
#' @param upregulated Boolean stating whether to look for the upregulated or downregulated genes.
#'
#' @return An object of class "data.frame"
#' @export
#'
#' @examples
#' \dontrun{
#' results_dge <- DESeq2::results(DESeq2::DESeq(DESeqDataSet))
#' gotermAnalysis(results_dge, ontologytype = "BP", upregulated = FALSE)
#' }
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
