#' @title Dataset containing measles numbers from EU countries
#' @description Data on measles cases cases and population numbers in EU countries from 2018 and 2019
#' European Centre for Disease Prevention and Control and Eurostat Data Browser
#' @format A dataframe with 744 rows and 8 variables:
#' \describe{
#'   \item{CountryName}{character Name of the country}
#'   \item{Total}{double Total number of cases in that year}
#'   \item{incidence}{double Incidence of that year}
#'   \item{labconf}{double Total number of lab confirmed cases in that year}
#'   \item{cases}{double Number of cases}
#'   \item{year}{character The year}
#'   \item{month}{character The month}
#'   \item{population}{double Population count of that year}
#'   }
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
#' data("measlesdata")
#' cases <- measlesdata$cases
#' }
#'
"measlesdata"
