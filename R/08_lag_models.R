library(tidyverse)
library(spdep)

load("data/LMresults_with_zeros.RDS")

load("data/06_idw_weights2.RData")

idw_matrix_small <- idw_matrix


load("data/06_idw_weights.RData")

load("data/04_spatial_joins.RData")

idw_matrix_big <- idw_matrix

points_spatial_join_log <- points_spatial_join %>%
  filter(pbe_rate != 0) %>%
  mutate(log_pbe_rate = log(pbe_rate * 100))

modeling_data_no_zero <- points_spatial_join_log %>%
  dplyr::select(c("percent_bachelors_degree" , "percent_white" , "percent_foreign_born" , "estimate_median_age_total", "log_pbe_rate", "pbe_rate"))

lag_no_zeros <- spdep::lagsarlm(log_pbe_rate ~ . -pbe_rate, data = modeling_data_no_zero, listw = idw_matrix_small, type = "lag")

mixed_no_zeros <- spdep::lagsarlm(log_pbe_rate ~ . -pbe_rate, data = modeling_data_no_zero, listw = idw_matrix_small, type = "mixed")


modeling_data_no_zero <- modeling_data_no_zero %>%
  mutate(resids = log_pbe_rate - lag_no_zeros$fitted.values,
         fitted_vals = lag_no_zeros$fitted.values)

ggplot(modeling_data_no_zero) +
  geom_point(aes(x = fitted_vals, y = resids), color = "#94618E") +
  geom_smooth(aes(x = fitted_vals, y = resids), color = "#49274A", se = FALSE, size = 1.2) +
  geom_hline(yintercept = 0, color = "#d9B310", size = 1.2, linetype = 2) +
  theme(plot.background = element_rect(fill = "#F8EEE7"),
        panel.background = element_rect(fill = "#F8EEE7")) +
  labs(title = "Residual plot for spatial lag model",
       y = "Residuals",
       x = "Fitted values")
             