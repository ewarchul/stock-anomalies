library(tidyverse)
library(magrittr)
library(R6)
library(mlr3)


#' @title Anomaly Detection Task
#'
#' @description 
#' This task specializes [TaskClassif] for anomaly detection problems.
#' [AnomalyTask] doesn't lose information about time in data frame and
#' return data as a [tibble::tibble()]

AnomalyTask = R6Class("AnomalyTask", 
  inherit = TaskClassif, 
  public = list(
    time_sequence = NULL,
    #' @description
    #' Function creates a new instance of anomaly detection task
    #'
    #' @param val_col column name [String] with value of time series
    #' @param time_col column name [String] with time information
    initialize = function(id, backend, target, val_col, time_col, positive = NULL) {
      self$time_sequence = backend[[time_col]]
      raw_backend = 
        backend %>%
          dplyr::select(rlang::sym(val_col), rlang::sym(target))
      super$initialize(id = id, backend = raw_backend, target = target, positive = positive)
      if (!is.null(positive)) {
        self$positive = positive
      }
    },
    #' @description
    #' Function calls `$data` from parent class [i.e TaskClassif] 
    #' and add column with the time sequence which is lost due to [data.table::data.table()]
    #' as a DataBackend function.
    #' 
    #' @return tibble data frame with time column 
    data = function(rows = NULL, cols = NULL) {
        super$data(rows = rows, cols = cols) %>%
        as_tibble() %>%
        dplyr::mutate(time = self$time_sequence)
    }
  )
)
