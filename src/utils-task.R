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
  lags = 
    1:win_size %>%
    purrr::map(function(lag) {
      data %>%
        dplyr::transmute(
                      !!rlang::sym(paste(key, "lag", lag, sep = "_")) := dplyr::lag(!!rlang::sym(key), lag) 
                      )
    }) %>%
    purrr::reduce(dplyr::bind_cols)
  dplyr::bind_cols(data, lags)
}
