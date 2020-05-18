library(tidyverse)
library(magrittr)

get_quant = function(data) {
  data$time[2] - data$time[1]
}

generate_timeSeq = function(data, index, length) {
  timeQuant = 
    get_quant(data)
  start_date = 
    data$time[index]
  end_date = 
    start_date + timeQuant*(length - 1)
  seq(start_date, end_date, by = timeQuant) 
}

generate_pointAnomalies = function(data, col, indices, n, st_coeff) {
  values = 
    data %>%
      dplyr::slice(indices) %>%
      dplyr::pull(!!rlang::sym(col))
  std_dev = sd(values)
  values %>%
    purrr::map_dbl(function(val) {
              val + st_coeff*3*std_dev
    })
}

generate_shiftAnomalies = function(data, col, index, length, st_coeff) {
  val = 
    data %>% 
    purrr::pluck(col, index)
  anomaly_center =
    val + val*st_coeff
  stats::rnorm(length, mean = anomaly_center)
}

impute_randomPointAnomaly = function(data, n, col, st_coeff = 0.5) {
  indices = 
    sample(1:nrow(data), n)
  anomalies = 
    data %>%
      generate_pointAnomalies(col, indices, n, st_coeff)
  data[[col]][indices] = anomalies
  data[["label"]][indices] = TRUE
  data
}

impute_randomShiftAnomaly = function(data, col, length, st_coeff = 0.5) {
  index = sample(1:(nrow(data) - length), 1)
  time_seq = 
    generate_timeSeq(data, index, length)
  anomalies =  
    data %>%
      generate_shiftAnomalies(col, index, length, st_coeff) 
  data[[col]][data$time %in% time_seq] = anomalies
  data[["label"]][data$time %in% time_seq] = TRUE
  data
}
