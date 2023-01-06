#' Calculate the sum, mean, median and standard deviation of data by group.
#'
#' @param data Object of class "data.frame".
#' @param groupBy String specifying what columns to group by.
#'
#' @return An object of class "data.frame".
#' @export
#'
#' @examples
#' {
#' data("measlesdata")
#' dataSummarizer(measlesdata, groupBy = c("CountryName", "year"))
#' }
dataSummarizer <- function(data, groupBy = "CountryName"){
  data %>% dplyr::group_by_at(groupBy) %>%
    dplyr::summarize(total = sum(cases, na.rm = TRUE),
                     mean = mean(cases, na.rm = TRUE),
                     median = stats::median(cases, na.rm = TRUE),
                     standarddeviation = stats::sd(cases, na.rm = TRUE)) %>%
    dplyr::arrange(desc(mean))
}
