source("../src/anomaly-task.R")
source("../src/anomaly-model-LOF.R")
source("../src/data-preparation.R")
source("../src/data-generation.R")
source("../src/data-visualization.R")

config = read_yaml("../data/experiment.yml")
wow_data = prepare_WoWToken("../data/history_prices_full.json")
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

wow_anomalies %>%
  filter(label == "TRUE")

wow_anomalies %>% plot_ts()
wow_anomalies %>% plot_ts(start_date = "2020-01-14 10:30:21", end_date = "2020-04-10 10:30:21")