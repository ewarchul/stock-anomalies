library(tidyverse)
library(magrittr)
library(R6)
library(here)
source(here::here("src", "utils-task.R"))
source(here::here("src", "data-preparation.R"))


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
              dplyr::select(!!rlang::sym(target)) 
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

AnomalyTaskConfig = R6::R6Class("AnomalyTaskConfig", 
  inherit = AnomalyTask,
  public = 
    list(
      initialize = function(config_path) {
          config = read_yaml(config_path)
          data = prepare_experiment_data(config_path = config_path)
          super$initialize(
              id = config$experiment_point_anomalies$task_id,
              data = data,
              key = "price",
              time = "time",
              target = "label",
              window_size = config$experiment_point_anomalies$window_size
              )
          }
      )
)


