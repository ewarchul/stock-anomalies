library(tidyverse)
library(magrittr)


run_exp = function(models, task = NA) {
   task_data = 
     task$df
   task_id = 
     ncol(task$df)
   models %>% purrr::map(function(model) {
      id = 
        paste("model", model$model_id, "task",  
      result =  model$predict(task_data)

  })
}

