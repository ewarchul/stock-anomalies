library(tidyverse)
library(yaml)
library(magrittr)
library(lambdass)
library(lubridate)
library(tsibble)
library(jsonlite)
library(here)

#' Function composition infix operator
#'
#' @param .f function b -> c
#' @param .g function a -> b
#' @return function a -> c
#' @examples
#' abs_mean = abs() %.% mean()
#' abs_mean(c(-5, 5)) == 10

`%.%` = function(.f, .g)
  purrr::compose(.g, .f)

#' Generic data reading
#' 
#' @description function reads file with data from directory ./data with specific data format
#' @param fn function to handle with data format
#' @param ... filename

read_data = function(fn, ...) {
  fn(here::here("data", ...))
}

#' JSON file reading
#' 
#' @param filename JSON filename

read_json = function(filename) { 
  read_data(jsonlite::read_json, filename)
}

#' YAML file reading
#' 
#' @param filename yaml filename

read_yaml = function(filename) {
  read_data(yaml::read_yaml, filename)
}

#' Parse WoW JSON to data frame
#'
#' @description function maps loaded JSON object to data frame
#' @param x JSON object

json_to_dfWoW = function(x) {
  realms = 
    names(x)
  realms %>%
    purrr::map_df(function(realm) {
        x %>%
          purrr::pluck(realm) %>%
          purrr::map_df(data.frame) %>%
          dplyr::mutate(region = realm)
    })
}

#' Create time series tibble
#'
#' @description function cast data frame to tsibble data frame with specified key and index names
#' @param dfx data frame   

create_tibble = function(dfx) {
  dfx %>% 
    dplyr::mutate(time = lubridate::as_datetime(time)) %>%
    tibble::as_tibble(key = time, index = price) 
}

#' Prepare WoW data
#' 
#' @description function combines reading, parsing and casting function to create tsibble object with
#' WoW Token price data
#' @param filename filename with WoW Token prices (JSON)

prepare_WoWToken = function(filename) {
  fn = 
    read_json %.% json_to_dfWoW %.% create_tsibble
  fn(filename)
}

#' Add labels
#'
#' @description function adds label to data frame row indicating about anomaly
#' @param dfx data frame with time series data
#' @param key column name with time series data
#' @param pred predicate a -> Bool
#' @examples
#' wow_data = prepare_WoWToken("wtoke-30d.json")
#' wow_ds = generate_df(price, x %->% {x > mean(x)})

generate_df = function(dfx, key, pred = NA) { 
  key =
    rlang::enquo(key)
  if (is.na(pred))
    dfx %>% 
      dplyr::mutate(label = FALSE)
  else 
    dfx %>%
      dplyr::mutate(label = dplyr::if_else(pred(!!key), TRUE, FALSE))
}


#' Add labels from config file
#' @description function adds label to data frame from YAML config file 
#' @param dfx data frame with time series data
#' @param filename YAML config file with dates cosidered as an anomaly  

add_configAnomalies = function(dfx, filename) {
  labels = 
    read_config(filename) %>%
    purrr::map(lubridate::as_datetime) %>%
    unlist
  dfx %>% 
    dplyr::mutate(label = 
                    dplyr::if_else(time %in% labels, 1, 0))
}

#' Create time series tibble
#' @description function cast data frame to tsibble data frame with specified key and index names, also calculates price 
#' @param wig data frame with time series data

c_tssibble = function(wig){
    price <- (wig$Otwarcie + wig$Najwyzszy+ wig$Najnizszy + wig$Zamkniecie)/4
    tsibble(price = price, date = wig$Data, key = date, index = price)
    
}
#' Prepare stock (WIG20) data
#' 
#' @description function combines reading and casting function to create tsibble object with
#' stock price data
#' @param filename filename with WIG20 prices (CSV)
prepare_Stock = function(filename) {
  fn = 
    read_csv %.% c_tssibble
  fn(filename)
}
