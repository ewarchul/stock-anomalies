source(here::here("src", "anomaly-model.R"))


#' Class representing LOF model
#' 
#' @description
#' Concrete class of abstract base class Model for LOF anomaly detector.

ModelLOF = R6::R6Class("ModelLOF",
  inherit = Model,
  public = 
    list(

         #' LOF model constructor
         #' 
         #' @description
         #' function creates LOF model as a partial function with given `params` list
         #` i.e `list("k" = ...)`. 
         #' 
         #' @param params named list of params

         initialize = function(params = NULL) {
          super$initialize("LOF")
            self$param_set$k = controlParam(params, "k", 10)
            self$model_id =
              paste0(self$model_id, "-k-", self$param_set$k)
          self$model_struct = 
             purrr::partial(
                DescTools::LOF, 
                k = self$param_set$k
              )
         },

         #' Predict values
         #'
         #' @description
         #' function assign anomaly scores for given data frame
         #' and save result of prediction to `predict_state` field.
         #' @param data data frame

        predict = function(data) {
          data %<>% drop_na
          self$predict_state = 
            self$model_struct(data = data)
         },

         #' Print model
         #' 
         #' @description
         #' function prints model to standard output

         print = function() {
           super$print()
         }
     )
)
