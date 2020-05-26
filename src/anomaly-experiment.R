library(tidyverse)
library(magrittr)
library(furrr)

#' Run experiment
#'
#' @description 
#' Function evaluate list of models [AnomalyModel] on given task [Task].
#' @param models list of models [AnomalyModel]
#' @param task AnomalyModel type instance
#' @param key name of variable representing data in TS
#'
#' @return list of data frames
#' @examples
#' results = 
#'  run_exp(list(ModelLOF$new(...), ModelSVM$new(...), task_1, "price")

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


