library(tidyverse)
library(spdep)
library(GGally)
library(usdm)
library(summarytools)

here::here()

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

points_spatial_join_with_zero <- points_spatial_join  

modeling_data_with_zero <- points_spatial_join_with_zero %>%
  dplyr::select(c("percent_bachelors_degree" , "percent_white" , "percent_foreign_born" , "estimate_median_age_total",  "pbe_rate"))

descr(modeling_data_with_zero, style = "rmarkdown", transpose = TRUE)

ols_model <- lm(log_pbe_rate ~ percent_bachelors_degree + percent_white + percent_foreign_born + estimate_median_age_total, data = points_spatial_join_log)

ggpairs(data = points_spatial_join_log, columns = c("percent_bachelors_degree" , "percent_white" , "percent_foreign_born" , "estimate_median_age_total", "log_pbe_rate"))


points_spatial_join_log %>%
  dplyr::select(c("percent_bachelors_degree" , "percent_white" , "percent_foreign_born" , "estimate_median_age_total")) %>%
  vif()


descr(modeling_data_no_zero, style = "rmarkdown", transpose = TRUE)

# map the residual values

LMtests <- lm.LMtests(ols_model, listw = idw_matrix_small, test = "all")

ols_model_2 <- lm(pbe_rate ~ percent_bachelors_degree + percent_white + percent_foreign_born + estimate_median_age_total, data = points_spatial_join_with_zero)


LMtests2 <- lm.LMtests(ols_model_2, listw = idw_matrix_big, test = "all")
summary(LMtests2)
BRRR::skrrrahh(4)
