library(tidyverse)
library(magrittr)

#' Get time difference between consecutive values
#' 
#' @description function computes time differnece
#' between two consecutive values of given time series. 
#' It is assumed that every consecutive values have the same
#' distance.
#' @param data data frame with time series (i.e it contains index column)

get_quant = function(data) {
  data$time[2] - data$time[1]
}

#' Time sequence generator
#'
#' @description function generates time sequnce with given length.
#' @param data data frame with time series
#' @param index number of row which is first element of the sequence
#' @param length length of the sequnce

generate_timeSeq = function(data, index, length) {
  timeQuant = 
    get_quant(data)
  start_date = 
    data$time[index]
  end_date = 
    start_date + timeQuant*(length - 1)
  seq(start_date, end_date, by = timeQuant) 
}

#' Point anomalies generator
#'
#' @description helper function generates anomalies in moments denoted by the given indices 
#' @param data data frame with time series
#' @param col column with value of time serie
#' @param indices 
#' @param n amount of anomalies
#' @param st_coeff control coefficient 

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

#' Interval anomalies generator
#'
#' @description 
#' function generates anomalies in randomly choosen interval of
#' given time series.
#' @param data data frame with time series
#' @param col column with value of time serie
#' @param index 
#' @param length length of generated interval
#' @param st_coeff control coefficient 

generate_intervalAnomalies = function(data, col, index, length, st_coeff) {
  val = 
    data %>% 
    purrr::pluck(col, index)
  anomaly_center =
    val + val*st_coeff
  stats::rnorm(length, mean = anomaly_center)
}

#' Impute point anomalies into TS
#'
#' @description function puts point anomalies into data frame with TS
#' @param col column with value of time serie
#' @param n amount of anomalies
#' @param st_coeff control coefficient 

impute_randomPointAnomaly = function(data, col, n, st_coeff = 0.5) {
  indices = 
    sample(1:nrow(data), n)
  anomalies = 
    data %>%
      generate_pointAnomalies(col, indices, n, st_coeff)
  data[[col]][indices] = anomalies
  data[["label"]][indices] = TRUE
  data
}

#' Impute interval with anomalies into TS
#'
#' @description function puts interval anomalies into data frame with TS
#' @param col column with value of time serie [String]
#' @param length length of interval
#' @param st_coeff control coefficient 

impute_randomIntervalAnomaly = function(data, col, length, st_coeff = 0.5) {
  index = sample(1:(nrow(data) - length), 1)
  time_seq = 
    generate_timeSeq(data, index, length)
  anomalies = data %>%
                generate_intervalAnomalies(col, index, length, st_coeff) 
  data[[col]][data$time %in% time_seq] = anomalies
  data[["label"]][data$time %in% time_seq] = TRUE
  data
}

#' Impute intervals with anomalies into TS
#'
#' @description function puts intervals anomalies into data frame with TS
#' @param n number of intervals
#' @param col column with value of time serie [String]
#' @param length length of interval
#' @param st_coeff control coefficient 


impute_randomIntervalsAnomaly = function(data, n, col, length, st_coeff = 0.5) {
  for (it in 1:n)
    data %<>%
      impute_randomIntervalAnomaly(col = col, length = length, st_coeff)
  data
}
