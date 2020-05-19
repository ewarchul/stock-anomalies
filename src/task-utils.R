library(tidyverse)
library(magrittr)

#' Add lagged columns 
#' 
#' @description 
#' todo
#' @param data todo
#' @param key todo 
#' @param win_size  todo
#'
#' @examples todo

add_lag = function(data, key, win_size) {
  lags = 
    1:w_size %>%
    purrr::map(function(lag) {
      data %>%
        dplyr::transmute(
                      !!rlang::sym(paste(key, "lag", lag, sep = "_")) := dplyr::lag(!!rlang::sym(key), lag) 
                      )
    }) %>%
    purrr::reduce(dplyr::bind_cols)
  dplyr::bind_cols(data, lags)
}
