library(tidyverse)
library(magrittr)
library(R6)
library(mlr)

source("task-utils.R")

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
         initialize = function(id, data, key, time, target, window_size) {
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
         }
    )
)

  
