#' Generate a figure containing the most abundant GO-terms
#'
#' @param goterm_results Object of class "data.frame", output from function gotermAnalysis().
#' @param padj_method String defining what adjustment method to use. Options: "holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none".
#' @param filter_from Numeric value that determines the minimum number of times a GO-term needs to appear.
#' @param filter_to Numeric value that determines the maximum number of times a GO-term can appear.
#' @param topamount Numeric value that determines the number of GO-terms plotted.
#' @param plot_title String defining the plot title.
#'
#' @return An object of class "ggplot".
#' @export
#'
#' @examples
#' \dontrun{
#' gotermPlot(gotermAnalysis_results,
#' topamount = 5,
#' plot_title = "Top 5 upregulated GO-terms")
#' }
gotermPlot <- function(goterm_results, padj_method = "BH", filter_from = 5, filter_to = 500, topamount = 10, plot_title) {
  goterm_results$padj <- stats::p.adjust(goterm_results$Pvalue, method = padj_method)
  goterm_results <- goterm_results %>% dplyr::filter(Count > filter_from) %>% dplyr::filter(Count < filter_to)
  goterm_results_top <- goterm_results[order(goterm_results$padj)[1:topamount],]
  goterm_results_top$Term <- factor(goterm_results_top$Term,
                                    levels = goterm_results_top$Term[
                                      order(goterm_results_top$padj, decreasing = TRUE)])

  goterm_results_top %>% data.frame() %>% ggplot2::ggplot(ggplot2::aes(x = Term, y = -log10(padj))) +
    ggplot2::geom_point() +
    ggplot2::coord_flip() +
    ggplot2::labs(title = plot_title,
                  x = "GO terms",
                  y = expression(-log[10](adjusted~italic(P)~value)))+
    ggplot2::theme_minimal()
}
