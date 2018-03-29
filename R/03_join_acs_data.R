library(tidyverse)
library(sf)

load("data/acs_data_clean.RData")


demographic_data_tracts <- total_pop_tracts_clean %>%
  left_join(education_attain_tracts_clean, by = c("GEOID", "NAME")) %>%
  left_join(foreign_born_tracts_clean, by = c("GEOID", "NAME")) %>%
  left_join(HH_median_income_tracts_clean, by = c("GEOID", "NAME")) %>%
  left_join(hisp_latino_origin_clean, by = c("GEOID", "NAME")) %>%
  left_join(median_age_tracts_clean, by = c("GEOID", "NAME")) %>%
  left_join(race_tracts_clean, by = c("GEOID", "NAME")) %>%
  arrange(GEOID)

cross_geometry <- cross_geometry %>%
  arrange(GEOID)


sum(demographic_data_tracts$GEOID == cross_geometry$GEOID) # should be 8041

demographic_data_tracts_sf <- demographic_data_tracts %>%
  mutate(geometry = cross_geometry$geometry) %>%
  select(-variable) %>%
  st_as_sf()

save(demographic_data_tracts_sf, file = "data/demographic_variables_sf.RData")
