library(tidyverse)
library(isotree)
library(e1071)
library(DescTools)
library(stats)
library(magrittr)
library(mlr3)
library(R6)



#' Anomaly detector class 
#'
#' @description 
#' Abstract class for model employed to detect anomalies.

Model = R6::R6Class("Model", 
  public = 
    list(

      #' @field model_id name of model
      model_id = NULL,

      #' @field model_struct field contains model object 
      #' with `predict()` method
      model_struct = NULL,

      #' @field model_state 
      model_state = NULL,

      #' @field predict_state contains output of prediction
      #' on given data set
      predict_state = NULL,

      #' @field param_set list of paremeters 
      param_set = list(),

      #' Abstract constructor of model
      #' 
      #' @description
      #' function creates new object of this class.
      initialize = function(id) {
        self$model_id = id
      },

      #' Construct model
      #' 
      #' @description
      #' function creates model on given train data set 
      #' @param data data frame
      train = function(data) {
        self$model_state = data
      },

      #' Assign scores
      #'
      #' @description
      #' function assing anomaly scores for given data set
      #' @param data data frame
      predict = function(data) {
        self$predict_state = data
      },

      #' Print object
      #'
      #' @description
      #' function prints model to stdout
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

#' Set parameter value
#'
#' @description 
#' function sets given or default parameter value.
#' @param params named list of parameters
#' @param name name of parameter 
#' @param default default value of paramter with given name
#'
#' @examples

controlParam = function(params, name, default) {
  v = params[[name]]
  if (is.null(v))
    return (default)
  else
    return (v)
}

