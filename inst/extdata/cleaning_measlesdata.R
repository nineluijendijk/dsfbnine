#R script used to create the measlesdata dataset.

data2019 <- readxl::read_excel(here::here("inst/extdata/measlesdata_2019.xlsx"), na = ".")
data2018 <- readxl::read_excel(here::here("inst/extdata/measlesdata_2018.xlsx"))
datapopulation <- readxl::read_excel(here::here("inst/extdata/EU_population.xlsx"),
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
