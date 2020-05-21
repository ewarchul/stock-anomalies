source("anomaly-model.R")

ModelLOF = R6::R6Class("ModelLOF",
  inherit = Model,
  public = 
    list(
         initialize = function(params = NULL) {
          super$initialize("LOF")
             
            self$param_set$k = controlParam(params, "k", 10)
             
          self$model_struct = 
             purrr::partial(
                DescTools::lof, 
                k = self$param_set$k
              )
         },
         train = function(data) {
           self$model_state =
             self$model_struct(df = data)

          },
         predict = function(data) {
          self$predict_state = 
            predict(self$model_state, data)
         },
         print = function() {
           super$print()
         }
     )
)
