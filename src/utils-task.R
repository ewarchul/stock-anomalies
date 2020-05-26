library(tidyverse)
library(magrittr)

#' Add lagged columns 
#' 
#' @description 
#' Proceses data table with moving window, adds columns containing samples laged by 1 sample, 2 samples ... to win_size-1 samples.  
#' @param data table with data to be processed 
#' @param key name of column to be processed with moving window
#' @param win_size size of moving window 
#'
#' @examples todo

add_lag = function(data, key, win_size) {
  if(win_size) {
    lags = 
      1:win_size %>%
      purrr::map(function(lag) {
        data %>%
          dplyr::transmute(
                        !!rlang::sym(paste(key, "lag", lag, sep = "_")) := dplyr::lag(!!rlang::sym(key), lag, default = first(!!rlang::sym(key))) 
                        )
      }) %>%
      purrr::reduce(dplyr::bind_cols)
    dplyr::bind_cols(data, lags)
  } else 
      data
}

#' Map config to data frame 
#'
#' @description 
#' function reads YAML config with experiment information 
#' and create data frame which is used in further steps 
#' to create object of class [AnomalyTaskConfig].
#' @param config_path YAML config file name

prepare_experiment_data = function(config_path) {
  config = read_yaml(config_path)
  prep_func = ifelse(config$experiment_point_anomalies$data_source == "wow",
                     prepare_WoWToken,
                     prepare_Stock)
  data = 
    prep_func(config$experiment_point_anomalies$data_path) %>%
    generate_df(key = time)

  anomalie_number = config$experiment_point_anomalies$point_anomalies_number
  anomalie_length = config$experiment_point_anomalies$interval_anomaly_length
  anomalie_size = ifelse(config$experiment_point_anomalies$amplitude == "small", 0.2, 0.8)  
  
  if (anomalie_length > 0) {
      data %>% 
        impute_randomPointAnomaly(col = "price", n = anomalie_number, st_coeff = anomalie_size) %>%
        impute_randomIntervalAnomaly(col = "price", length = anomalie_length, st_coeff = anomalie_size)
  } else {
      data %>% 
        impute_randomPointAnomaly(col = "price", n = anomalie_number, st_coeff = anomalie_size) 
  }
}

