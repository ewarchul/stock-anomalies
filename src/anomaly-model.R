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
      }
  )
)

ModelIsoForest = R6::R6Class("ModelIsoForest",
  inherit = Model,
  public = 
    list(
         initialize = function(params = NULL) {
          super$initialize("iForest")
          self$param_set$ntrees = controlParam(params, "ntrees", 500)
          self$param_set$ntry = controlParam(params, "ntry", 3)
          self$param_set$prob_pick_avg_gain = controlParam(params, "prob_pick_avg_gain", 0)
          self$param_set$prob_pick_pooled_gain = controlParam(params, "prob_pick_pooled_gain", 0)
          self$param_set$prob_split_avg_gain = controlParam(params, "prob_split_avg_gain", 0)
          self$param_set$prob_split_pooled_gain = controlParam(params, "prob_split_pooled_gain", 0)
          self$param_set$min_gain = controlParam(params, "min_gain", 0)
          self$param_set$categ_split_type = controlParam(params, "categ_split_type", "subset")
          self$param_set$all_perm = controlParam(params, "all_perm", FALSE)
          self$param_set$weights_as_sample_prob = controlParam(params, "weights_as_sample_prob", TRUE)
          self$param_set$sample_with_replacement = controlParam(params, "sample_with_replacement", FALSE)
          self$param_set$penalize_range = controlParam(params, "penalize_range", TRUE)
          self$param_set$weigh_by_kurtosis = controlParam(params, "weigh_by_kurtosis", FALSE)
          self$param_set$coefs = controlParam(params, "coefs", "normal")
          self$param_set$assume_full_distr = controlParam(params, "assume_full_distr", TRUE)
          self$param_set$build_imputer = controlParam(params, "build_imputer", FALSE)
          self$param_set$output_imputations = controlParam(params, "output_imputations", FALSE)
          self$param_set$min_imp_obs = controlParam(params, "min_imp_obs", 3)
          self$param_set$depth_imp = controlParam(params, "depth_imp", "higher")
          self$param_set$weigh_imp_rows = controlParam(params, "weigh_imp_rows", "inverse")
          self$param_set$output_score = controlParam(params, "output_score", FALSE)
          self$param_set$output_dist = controlParam(params, "output_dist", FALSE)
          self$param_set$square_dist = controlParam(params, "square_dist", FALSE)
          self$param_set$random_seed = controlParam(params, "random_seed", 1)

          self$model_struct = 
             purrr::partial(
              isotree::isolation.forest, 
              sample_weights = self$param_set$sample_weights,
              ntrees = self$param_set$ntrees, 
              ntry = self$param_set$ntry,
              prob_pick_avg_gain = self$param_set$prob_pick_avg_gain, 
              prob_pick_avg_gain = self$param_set$prob_pick_pooled_gain, 
              prob_split_avg_gain = self$param_set$prob_split_avg_gain, 
              prob_split_pooled_gain = self$param_set$prob_split_pooled_gain,
              min_gain = self$param_set$min_gain, 
              categ_split_type = self$param_set$categ_split_type,
              all_perm = self$param_set$all_perm, 
              weights_as_sample_prob = self$param_set$weights_as_sample_prob,
              sample_with_replacement = self$param_set$sample_with_replacement, 
              penalize_range = self$param_set$penalize_range, 
              weigh_by_kurtosis = self$param_set$weigh_by_kurtosis, 
              coefs = self$param_set$coefs, 
              assume_full_distr = self$param_set$assume_full_distr,
              build_imputer = self$param_set$build_imputer,
              output_imputations = self$param_set$output_imputations,
              min_imp_obs = self$param_set$min_imp_obs,
              depth_imp = self$param_set$depth_imp,
              weigh_imp_rows = self$param_set$weigh_imp_rows,
              output_score = self$param_set$output_score, 
              output_dist = self$param_set$output_dist,
              square_dist = self$param_set$square_dist,
              random_seed = self$param_set$random_seed
              )
         },
         train = function(data, sample_size = NULL, max_depth = NULL) {
           self$model_state =
             self$model_struct(
                   df = data,
                   sample_size = ifelse(is.null(sample_size), nrow(data), sample_size),
                   max_depth = ifelse(is.null(max_depth), ceiling(log2(nrow(data))), max_depth),
                   missing_action = ifelse(min(3, ncol(data)) > 1, "impute", "divide"),
                   new_categ_action = ifelse(min(3, ncol(data)) > 1, "impute", "weighted")
                 )

          },
         predict = function(data) {
          self$predict_state = 
            predict(self$model_state, data)
         }
     )
)

ModelSVM = R6::R6Class("ModelSVM",
  inherit = Model,
  public = 
    list(
         initialize = function(params = NULL) {
          super$initialize("SVM")
             
            self$param_set$kernel = controlParam(params, "kernel", "linear")
            self$param_set$scale = controlParam(params, "scale", 1)
            self$param_set$degree = controlParam(params, "degree", 3)
            self$param_set$gamma = controlParam(params, "gamma", 1) #default 1/data dimention 
            self$param_set$coef0 = controlParam(params, "coef0", 0)
            self$param_set$cost = controlParam(params, "cost", 1)
            self$param_set$nu = controlParam(params, "nu", ????)
            self$param_set$tolerance = controlParam(params, "tolerance", 0.001)
            self$param_set$epsilon = controlParam(params, "epsilon", 0.1)
            self$param_set$shrinking = controlParam(params, "shrinking", TRUE)
#           degree, gamma, coef0 - brakuje
             
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
         train = function(data, ...) {
           self$model_state =
             self$model_struct(
                   df = data,
                   type='one-classification',
                   ...
                 )

          },
         predict = function(data) {
          self$predict_state = 
            predict(self$model_state, data)
         }
     )
)
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
                   inner = if(robust)  1 else 2,
                   outer = if(robust) 15 else 0,
                   na.action = na.fail
                 )

          },
         predict = function(data) {
          self$predict_state = 
            predict(self$model_state, data)
         }
     )
)
             
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
             self$model_struct(
                   df = data,
                 )

          },
         predict = function(data) {
          self$predict_state = 
            predict(self$model_state, data)
         }
     )
)
