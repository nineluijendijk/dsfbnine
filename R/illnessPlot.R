#' Generate a graph showing illness numbers
#'
#' @param data Object of class "data.frame".
#' @param countries String specifying what countries to filter by.
#' @param years Integer specifying what years to filter by.
#' @param parameter Name of the column of interest, NOT in quotes.
#'
#' @return An object of class "ggplot".
#' @export
#'
#' @examples
#' \dontrun{
#' illnessPlot(data, countries = c("Netherlands", "Belgium", "France"),
#' years = 2020:2022, parameter = cases)
#' }
illnessPlot <- function(data, countries = "Spain", years = 2020,  parameter = cases){
  string <- deparse(substitute(parameter))
  data_filtered <- data %>% dplyr::filter(countriesAndTerritories %in% countries, year %in% years)
  data_filtered <- dplyr::mutate(data_filtered, "date" = paste(day, month, year, sep="/"))
  data_filtered$date <- as.Date(data_filtered$date, format="%d/%m/%Y")
  ggplot2::ggplot(data_filtered,
                  aes(x = date, y = {{parameter}}, group = countriesAndTerritories,
                      color = countriesAndTerritories))+
    ggplot2::geom_line()+
    ggplot2::labs(title = paste("Number of newly reported COVID-19", string, "over time by country"),
                  y = paste("Number of COVID-19", string),
                  x = "Date",
                  color = "Country")+
    ggplot2::scale_x_date(date_breaks = "1 month", date_labels = "%d-%m-%y")+
    ggplot2::scale_y_continuous(labels = scales::label_comma(), limits = c(0, NA))+
    ggplot2::theme_minimal()+
    ggplot2::theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
}
