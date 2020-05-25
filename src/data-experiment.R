source("../src/anomaly-task.R")
source("../src/anomaly-model-LOF.R")
source("../src/data-preparation.R")
source("../src/data-generation.R")
#' source("../src/data-visualization.R")
#' #' Prepare data based on config 
#' #'
#' #' @description reads data, inpute anomalies 
#' #' @param config_path path to config (yaml)
#' 
#' prepare_experiment_data = function(config_path) {
#'   config = read_yaml(config_path)
#'   print(config)
#'   if (config$experiment_point_anomalies$data_source == "wow"){
#'     wow_data = prepare_WoWToken(config$experiment_point_anomalies$data_path)
#'     data = wow_data %>%
#'       dplyr::filter(region == "eu") %>%
#'       generate_df(key = time)
#'   }else{
#'     wig_data = prepare_Stock(config$experiment_point_anomalies$data_path)
#'     data = wig_data %>%
#'       generate_df(key = time)
#'     
#'   }
#'   
#'   anomalie_number = config$experiment_point_anomalies$point_anomalies_number
#'   anomalie_length = config$experiment_point_anomalies$interval_anomaly_length
#'   anomalie_size = ifelse(config$experiment_point_anomalies$amplitude == "small", 0.8, 0.8)  
#'   
#'   if( anomalie_length > 0){
#'     anomalies = 
#'       data %>% 
#'       impute_randomPointAnomaly(col = "price", n = anomalie_number, st_coeff = anomalie_size) %>%
#'       impute_randomIntervalAnomaly(col = "price", length = anomalie_length, st_coeff = anomalie_size)
#'   }else{
#'     anomalies = 
#'       data %>% 
#'       impute_randomPointAnomaly(col = "price", n = anomalie_number, st_coeff = anomalie_size) 
#'   }
#' }
#' 
#' #' Prepare data based on config 
#' #'
#' #' @description reads data, inpute anomalies and returns task 
#' #' @param config_path path to config (yaml)
#' 
#' prepare_experiment = function(config_path) {
#'   config = read_yaml(config_path)
#'   data = prepare_experiment_data(config_path = config_path)
#'   experiment_task = 
#'     AnomalyTask$new(
#'       id = config$experiment_point_anomalies$task_id,
#'       data = data,
#'       key = "price",
#'       time = "time",
#'       target = "label",
#'       window_size = config$experiment_point_anomalies$window_size
#'     )
#' }

config_path = "../data/experiment.yml"

anomalies = AnomalyTask$new()
anomalies$pre

# anomalies %>% 
#   filter(label == "TRUE")
# anomalies %>% plot_ts()
#"../data/wig20_d.csv"
#"../data/wtoke-30d.json"
