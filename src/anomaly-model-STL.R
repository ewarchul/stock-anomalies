source("anomaly-model-STL.R")

ModelSTL = R6::R6Class("ModelSTL",
  inherit = Model,
  public = 
    list(
         initialize = function(params = NULL) {
          super$initialize("STL")
             
            self$param_set$s.window = controlParam(params, "s.window", "periodic")
            self$param_set$s.degree = controlParam(params, "s.degree", 0)
            self$param_set$t.window = controlParam(params, "t.window", NULL)
            self$param_set$t.degree = controlParam(params, "t.degree", 1) 
            self$param_set$l.window = controlParam(params, "l.window", 0) #nextodd(period)
            self$param_set$l.degree  = controlParam(params, "l.degree", self$param_set$t.degree)
            self$param_set$s.jump = controlParam(params, "s.jump", ceiling(self$param_set$s.window/10))
            self$param_set$t.jump= controlParam(params, "t.jump", ceiling(self$param_set$t.window/10))
            self$param_set$l.jump = controlParam(params, "l.jump", ceiling(self$param_set$l.window/10))
            self$param_set$robust = controlParam(params, "robust", FALSE)
             
          self$model_struct = 
             purrr::partial(
                stats::stl, 
                scale = self$param_set$scale,
                kernel = self$param_set$kernel,
                cost = self$param_set$cost,
                nu = self$param_set$nu,
                tolerance = self$param_set$tolerance,
                epsilon = self$param_set$epsilon,
                shrinking = self$param_set$shrinking
              )
         },
         train = function(data) {
           self$model_state =
             self$model_struct(
                   df = data,
                   inner = ifelse(robust, 1, 2)
                   outer = ifelse(robust, 15, 0)
                   na.action = na.fail
                 )

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

