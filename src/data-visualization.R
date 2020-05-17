library(tidyverse)
library(magrittr)
library(lubridate)

#' Plot time series
#'
#' @description function creates plot with raw time series data, anomalies and mean line
#' @param data data frame with time and price column
#' @param start_date start of time series 
#' @param end_date end of time series
#' @param if_anomalies binary flag: if TRUE then add anomaly indicator
#' @param if_mean binary flag: if TRUE then add mean line
#' @examples
#' TS %>% plot_ts(start_date = "2020-03-14 10:30:21", end_date = "2020-04-10 10:30:21")

plot_ts = function(data, start_date = NA, end_date = NA, 
                   if_anomalies = TRUE, if_mean = TRUE) {
    start_date %<>% lubridate::ymd_hms(tz='UTC')
    end_date %<>% lubridate::ymd_hms(tz='UTC')
    if(is.na(start_date) || is.na(end_date)) {
      dfx = 
        data
    }
    else {
      dfx = 
        data %>% 
        dplyr::filter(time %within% (start_date %--% end_date))
    }
    base_plot = 
      dfx %>%
      ggplot2::ggplot(aes(x = time)) + 
      ggplot2::geom_line(aes(y = price, color = "Dane"), key_glyph = "rect", alpha = 1) +
      ggplot2::theme_bw() +
      ggplot2::scale_color_manual(name = "", values = c("#00A08A", "#E6A0C4", "#7294D4")) +
      ggplot2::theme(
                     axis.title = element_text(size = 15, face = "bold"),
                     axis.text = element_text(size = 10, face = "bold"),
                     legend.text = element_text(size = 10, face = "bold"),
                     legend.key = element_rect(),
                     legend.position = c(0.89, 0.90)
                     ) +
      xlab("Czas") +
      ylab("Cena kupna [g]") +
      scale_x_datetime()
  if(if_mean) {
    mean = 
      dfx %>% 
        dplyr::pull(price) %>%
        mean()
    base_plot = 
      base_plot + 
      ggplot2::geom_hline(aes(yintercept = mean, color = "Średnia"), key_glyph = "rect", linetype = "dashed", alpha = 0.9)
  }
  if(if_anomalies) {
    anomalies = 
      dfx %>% 
        dplyr::filter(label)
    base_plot = 
      base_plot + 
      ggplot2::geom_point(aes(x = time, y = price, color = "Anomalie"), shape = 5, key_glyph = "rect", data = anomalies) +
      ggplot2::geom_vline(aes(xintercept = time), data = anomalies, color = "green", alpha = 0.15, size = 5)
  }
  base_plot
}

