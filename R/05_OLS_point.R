library(tidyverse)
library(broom)
load("data/04_spatial_joins.RData")

ols_modeling_data_tracts <- demographic_and_pbe_data_tract %>% # gather all the data I want for modeling with an OLS regression
  mutate(percent_hispanic = estimate_total_hispanic_or_latino/estimate_total_pop_hisp) %>%
  select(c(geoid, 
           estimate_total_pop, 
           moe_total_pop, 
           percent_bachelors_degree, 
           percent_white, 
           percent_foreign_born, 
           schools, 
           median_pbe_rate_tract, 
           enroll_tot_tract, 
           pbe_tot_tract, 
           weighted_mean_pbe_rate_tract, 
           estimate_hh_med_income, 
           moe_hh_med_income, 
           estimate_median_age_total, 
           moe_median_age_total, 
           percent_hispanic, 
           geometry)) %>%
  drop_na(schools) # include only tracts with at least one school

resid_model <- lm(estimate_hh_med_income ~ percent_white + percent_bachelors_degree, data = ols_modeling_data_tracts)

augmented_residuals <- augment(resid_model)

ols_modeling_data_tracts$residuals_white_bachelors_degree <- augmented_residuals$.resid

ols_model <- lm(data = ols_modeling_data_tracts,
                formula = log(weighted_mean_pbe_rate_tract) ~ residuals_white_bachelors_degree +
                  estimate_hh_med_income + estimate_median_age_total)
