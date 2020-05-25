library(tidyverse)
library(magrittr)


run_exp = function(models, task = NA, key) {
   task_data = task$df
   task_time = task$time_sequence
   task_labels = task$targets
   models %>% purrr::map(function(model) {
      id = 
        paste("model", model$model_id, "task", task$task_id, sep = "-") 
      predictions = 
        model$predict(task_data)
      vals = 
        task_data %>%
        dplyr::select(!!rlang::sym(key))
      tibble::tibble(
                     id = id,
                     time = task_time,
                     !!rlang::sym(key) := vals,
                     labels = task_labels, 
                     pred_labels = predictions
                     )

  })
}

