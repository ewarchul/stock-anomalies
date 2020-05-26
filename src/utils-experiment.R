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
  results %>% 
    purrr::map(function(result) {
      result %>%
        dplyr::mutate(!!rlang::sym(scores) := pred(!!rlang::sym(scores)))
  })
}


#' Compute ROC 
#'
#' @description
#' function computes data necessary to plot ROC curve.
#' @param experiment result
#' @param predictions column name with predictions [String]
#' @param truth column name with true labels [String]

get_ROC = function(result, predictions, truth) { 
  predictions %<>% rlang::sym()
  truth %<>% rlang::sym()
  roc_df = 
    result %>%
      pROC::roc(!!truth, !!predictions)
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

get_metrics = function(result) {
  err_data = 
    caret::confusionMatrix(factor(result$predictions), factor(result$truth))
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
#' @return [Tibble]
#' @seealso `get_metrics()`

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
