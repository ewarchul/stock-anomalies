library(tidyverse)
library(isotree)
library(e1071)
library(DescTools)
library(stats)
library(magrittr)
library(mlr3)
library(R6)

controlParam = function(params, name, default) {
  v = params[[name]]
  if (is.null(v))
    return (default)
  else
    return (v)
}

Model = R6::R6Class("Model", 
  public = 
    list(
      model_id = NULL,
      model_struct = NULL,
      model_state = NULL,
      predict_state = NULL,
      param_set = list(),
      initialize = function(id) {
        self$model_id = id
      },
      train = function(data) {
        self$train_state = data
      },
      predict = function(data) {
        self$predict_state = data
      },
      print = function() {
        cat(stringr::str_interp(
                     "Model: ${self$model_id}\n 
                     Params: ${self$param_set}\n
                     Model info: ${self$model_state}\n
                     Predicted values: ${self$predict_state}\n"
                     ))

      }
  )
)
