source("../src/anomaly-task.R")
source("../src/anomaly-model-LOF.R")
source("../src/data-preparation.R")
source("../src/data-generation.R")
source("../src/data-visualization.R")

#' Prepare wow toke data based on config 
#'
#' @description reads data, inpute anomalies 
#' @param data_path path to data (wow token - JSON)
#' @param config_path path to config (yaml)

prepare_experiment = function(data_path, config_path) {
  config = read_yaml(config_path)
  wow_data = prepare_WoWToken(data_path)
  anomalie_number = config$experiment_point_anomalies$point_anomalies_number
  anomalie_length = config$experiment_point_anomalies$interval_anomaly_length
  anomalie_size = ifelse(config$experiment_point_anomalies$amplitude == "small", 0.4, 0.8)
  wow_eu = wow_data %>%
    dplyr::filter(region == "eu") %>%
    generate_df(key = time)
  
  if( anomalie_length > 0){
    wow_anomalies = 
      wow_eu %>% 
      impute_randomPointAnomaly(col = "price", n = anomalie_number, st_coeff = anomalie_size) %>%
      impute_randomIntervalAnomaly(col = "price", length = anomalie_length, st_coeff = anomalie_size)
  }else{
    wow_anomalies = 
      wow_eu %>% 
      impute_randomPointAnomaly(col = "price", n = anomalie_number, st_coeff = anomalie_size) 
  }

}

config_path = "../data/experiment.yml"
data_path = "../data/history_prices_full.json"
wow_anomalies = prepare_experiment(data_path, config_path)
wow_anomalies %>% 
  filter(label == "TRUE")
wow_anomalies %>% plot_ts()
