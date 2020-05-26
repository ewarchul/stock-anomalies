
#' Class representing One Class SVM model
#' 
#' @description
#' Concrete class of abstract base class Model for OC-SVM anomaly detector.

ModelSVM = R6::R6Class("ModelSVM",
  inherit = Model,
  public = 
    list(

         #' One Class SVM model constructor
         #' 
         #' @description
         #' function creates OC-SVM model as a partial function with given `params` list
         #' @param params named list of params

         initialize = function(params = NULL) {
          super$initialize("SVM")
             
            self$param_set$kernel = controlParam(params, "kernel", "linear")
            self$param_set$scale = controlParam(params, "scale", 1)
            self$param_set$degree = controlParam(params, "degree", 3)
            self$param_set$gamma = controlParam(params, "gamma", 1) #default 1/data dimention 
            self$param_set$coef0 = controlParam(params, "coef0", 0)
            self$param_set$cost = controlParam(params, "cost", 1)
            self$param_set$nu = controlParam(params, "nu", 0.5) 
            self$param_set$tolerance = controlParam(params, "tolerance", 0.001)
            self$param_set$epsilon = controlParam(params, "epsilon", 0.1)
            self$param_set$shrinking = controlParam(params, "shrinking", TRUE)
             
          self$model_struct = 
             purrr::partial(
                e1071::svm, 
                scale = self$param_set$scale,
                kernel = self$param_set$kernel,
                cost = self$param_set$cost,
                nu = self$param_set$nu,
                tolerance = self$param_set$tolerance,
                epsilon = self$param_set$epsilon,
                shrinking = self$param_set$shrinking
              )
         },
      
         #' Construct One Class SVM
         #'
         #' @description
         #' function creates OC-SVM on given data set.
         #' @param data data frame
         #' @param ... internal params of SVM like kernel function

         train = function(data, ...) {
           self$model_state =
             self$model_struct(
                    
                    df = data,
                    type='one-classification',
                    probability = TRUE,
                    na.action = na.omit,
                   ...
                 )

          },

         #' Predict values
         #'
         #' @description
         #' function assign anomaly scores for given data frame
         #' and save result of prediction to `predict_state` field.
         #' @param data data frame

         predict = function(data) {
          self$predict_state = 
            predict(self$model_state, data, probability = TRUE)
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

