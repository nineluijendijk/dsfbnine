#' Dataset containing measles numbers from EU countries
#'
#'
#' Data on measles cases in EU countries and population numbers from
#' European Centre for Disease Prevention and Control and Eurostat Data Browser
#'
#' @docType data
#'
#' @usage data(measlesdata)
#'
#' @format An object of class "data.frame".
#'
#' @keywords datasets
#'
#' @references European Centre for Disease Prevention and Control (2020)
#' (\href{https://www.ecdc.europa.eu/en/publications-data/number-measles-cases-month-and-notification-rate-million-population-country-16}{ECDC})
#' , European Centre for Disease Prevention and Control (2019)
#' (\href{https://www.ecdc.europa.eu/en/publications-data/number-measles-cases-month-and-notification-rate-million-population-country-8}{ECDC})
#' , Eurostat Data Browser (2022)
#' (\href{https://ec.europa.eu/eurostat/databrowser/view/tps00001/default/table?lang=en}{Eurostat}).
#'
#' @examples
#' \donttest{
#' data(measlesdata)
#' cases <- measlesdata$cases
#' }
"measlesdata"
