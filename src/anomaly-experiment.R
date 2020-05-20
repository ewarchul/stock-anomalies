library(tidyverse)
library(magrittr)


run_exp = function(models, tasks) {
  list(models, tasks) %>%
    purrr::pmap(function(model, task) {
                  #' Todo

  })
}

