#' Arithmetic mean anomaly criterion
#' 
#' @description if value in time series is bigger than arithmetic mean then it's anomaly

mean_anomaly = function(x) {
  x > mean(x)
}
