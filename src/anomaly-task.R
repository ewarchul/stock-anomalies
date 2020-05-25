library(tidyverse)
library(magrittr)
library(R6)
library(mlr)
library(here)
source(here::here("src", "utils-task.R"))


#' @title Anomaly Detection Task
#'
#' @description 
#'

AnomalyTask = R6::R6Class("AnomalyTask", 
  public = 
    list(
         df = NULL,
         time_sequence = NULL,
         targets = NULL,
         task_id = NULL,
         initialize = function(id, data, key, time, target, window_size) {
           self$task_id = id
           self$df = 
             data %>%
              dplyr::select(!!rlang::sym(key)) %>%
              add_lag(key, window_size)
           self$targets = 
             data %>%
              dplyr::select(!!rlang::sym(target)) %>%
              base::factor()
           self$time_sequence =
             data %>%
              dplyr::select(!!rlang::sym(time))
         },
         print = function() {
           cat(stringr::str_interp(
                " \n 
                 Task ID: ${self$task_id}\n
                 Task backend info:\n
                 ncol: ${ncol(self$df)}\n
                 nrow: ${nrow(self$df)}\n
                 Target values: ${base::levels(self$targets)}\n"
                 )
           )
         }
    )
)

prepare_experiment_data = function(config_path) {
  config = read_yaml(config_path)
  print(config)
  if (config$experiment_point_anomalies$data_source == "wow"){
    wow_data = prepare_WoWToken(config$experiment_point_anomalies$data_path)
    data = wow_data %>%
      dplyr::filter(region == "eu") %>%
      generate_df(key = time)
  }else{
    wig_data = prepare_Stock(config$experiment_point_anomalies$data_path)
    data = wig_data %>%
      generate_df(key = time)
    
  }
  
  anomalie_number = config$experiment_point_anomalies$point_anomalies_number
  anomalie_length = config$experiment_point_anomalies$interval_anomaly_length
  anomalie_size = ifelse(config$experiment_point_anomalies$amplitude == "small", 0.8, 0.8)  
  
  if( anomalie_length > 0){
    anomalies = 
      data %>% 
      impute_randomPointAnomaly(col = "price", n = anomalie_number, st_coeff = anomalie_size) %>%
      impute_randomIntervalAnomaly(col = "price", length = anomalie_length, st_coeff = anomalie_size)
  }else{
    anomalies = 
      data %>% 
      impute_randomPointAnomaly(col = "price", n = anomalie_number, st_coeff = anomalie_size) 
  }
}

prepare_experiment = function(config_path) {
  config = read_yaml(config_path)
  data = prepare_experiment_data(config_path = config_path)
  experiment_task = 
    AnomalyTask$new(
      id = config$experiment_point_anomalies$task_id,
      data = data,
      key = "price",
      time = "time",
      target = "label",
      window_size = config$experiment_point_anomalies$window_size
    )
}

  
