library(furrr)

#' Transform scores 
#'
#' @description
#' function transforms real-value anomaly scores predicted by given model 
#' to target label i.e. value from {FALSE, TRUE} using given policy. 
#' For instance LOF model treats score much bigger than 1 (>> 1) as an anomaly.
#' @param results list of data frames with experiment results [Tibble]
#' @param scores name of variable which indicate scores in data frame [String]
#' @param pred predicate function i.e function with given signature Float -> Boolean
#' 
#' @examples
#' results %>% transform_scores("predictions", f.(x, x > 1.5))

transform_scores = function(results, scores, pred) {
  future::plan(multicore)
  results %>% 
    furrr::future_map(function(result) {
      result %>%
        dplyr::mutate(!!paste0(rlang::sym(scores), "_bool") := pred(!!rlang::sym(scores)))
  })
}


#' Compute ROC 
#'
#' @description
#' function computes data necessary to plot ROC curve.
#' @param experiment result
#' @param score column name with real-valued scores [String]
#' @param truth column name with true labels [String]

get_ROC = function(result, score, truth) { 
  roc_df = 
      pROC::roc(result[[truth]], result[[score]])
  tibble::tibble(
      sens = roc_df$sensitivities,
      spec = roc_df$specificities
  )
}

#' Compute metrics
#' 
#' @description 
#' function takes result of experiment and compute: 
#'  - precision
#'  - recall
#'  - F-measure
#' @param result data frame
#' @param predictions column name with Boolean predictions [String]
#' @param truth column name with true labels [String]


get_metrics = function(result, predictions, truth) {
  preds = 
    result %>%
      dplyr::pull(!!rlang::sym(predictions))
  truths = 
    result %>%
      dplyr::pull(!!rlang::sym(truth))
  err_data = 
    caret::confusionMatrix(factor(preds, levels = c(TRUE, FALSE)), factor(truths, levels = c(TRUE, FALSE)))
  tibble::tibble(
    precision = err_data$byClass["Pos Pred Value"],
    recall = err_data$byClass["Sensitivity"],
    F_measure = 2 * ((precision * recall) / (precision + recall))
    )
}

#' Process experiment results
#' 
#' @description
#' function takes list of experiment results [Tibble] and
#' compute evaluation metrics
#' @param results [Tibble]
#' @param metric_func function with type Tibble -> Tibble where the lhs arg is result of experiment
#' @return Tibble
#' @seealso `get_metrics()`

compute_metrics = function(results, metric_func, ...) {
  future::plan(multicore)
  results %>% 
    furrr::future_map_dfr(function(result) {
      exp_id = 
        result %>%
        dplyr::pull(id) %>%
        purrr::pluck(1)
      metrics = 
        result %>%
        metric_func(...) 
      metrics %>%
        dplyr::mutate(id = exp_id)
  })
}
