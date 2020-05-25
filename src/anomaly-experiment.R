library(tidyverse)
library(data.table)
library(magrittr)
library(furrr)
library(pROC)
library(caret)


#' [Model] -> Task -> [Tibble]

run_exp = function(models, task = NA, key) {
   task_data = task$df
   task_time = task$time_sequence %>% dplyr::pull()
   task_labels = task$targets %>% dplyr::pull()
   models %>% 
     furrr::future_map(function(model) {
        id = 
          paste("model", model$model_id, "task", task$task_id, sep = "-") 
        predictions = 
          model$predict(task_data)
        vals = 
          task_data %>%
          dplyr::pull(!!rlang::sym(key))
        tibble::tibble(
                       id = id,
                       time = task_time,
                       key = vals,
                       truth = task_labels, 
                       predictions = predictions
                       ) 
  }, .progress = TRUE)
}

#' [Tibble] -> String -> (Float -> Bool) -> [Tibble]
#'
#' @examples
#' results %>% transform_scores("predictions", f.(x, x > 1.5))

transform_scores = function(results, scores, pred) {
  results %>% 
    purrr::map(function(result) {
      result %>%
        dplyr::mutate(!!rlang::sym(scores) := pred(!!rlang::sym(scores)))
  })
}

get_ROC = function(result) { 
  roc_df = 
    result %>%
      pROC::roc(labels, pred_labels)
  tibble::tibble(
      sens = roc_df$sensitivities,
      spec = roc_df$specificities
  )
}

get_metrics = function(result) {
  err_data = 
    caret::confusionMatrix(factor(result$predictions), factor(result$truth))
  tibble::tibble(
    precision = err_data$byClass["Pos Pred Value"],
    recall = err_data$byClass["Sensitivity"],
    F_measure = 2 * ((precision * recall) / (precision + recall))
    )
}

compute_metrics = function(results) {
  results %>% 
    purrr::map(function(result) {
      exp_id = 
        result %>%
        dplyr::select(id) %>%
        dplyr::slice(1)
      metrics = 
        result %>%
        get_metrics() 
      dplyr::bind_cols(exp_id, metrics)
  })
}
