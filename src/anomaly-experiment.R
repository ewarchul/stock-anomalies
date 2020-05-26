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


