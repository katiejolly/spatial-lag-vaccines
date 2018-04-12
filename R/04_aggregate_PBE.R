library(tidyverse)
library(sf)
library(snakecase)

load("data/03_demographic_variables_sf.RData")

utm11N_ESPG <- 26911 # use the utm 11N projection

demographic_data_tracts_sf <- demographic_data_tracts_sf %>%
  st_transform(utm11N_ESPG) %>%
  mutate(percent_bachelors_degree = estimate_total_bachelor_degree/estimate_total_pop_educ,
         percent_white = estimate_total_white_alone/estimate_total_race,
         percent_foreign_born = estimate_total_foreign_born/estimate_total_pop)

demo_names <- to_any_case(names(demographic_data_tracts_sf), case = "snake")

names(demographic_data_tracts_sf) <- demo_names

pbe <- read_sf("california_schools_pbe/CA_schools_PBE.shp") %>%
  st_transform(utm11N_ESPG) %>%
  mutate(pbe_rate = PBETot/EnrollTot) %>%
  rename(school_name = Name)

pbe_names <- to_any_case(names(pbe), case = "snake")

names(pbe) <- pbe_names

points_spatial_join <- st_join(demographic_data_tracts_sf, pbe,  join = st_contains) %>%
  drop_na(school_name) %>%
  st_set_geometry(NULL) %>% # get rid of the tract geometry
  st_as_sf(coords = c("lon_dec", "lat_dec"), 
           crs = utm11N_ESPG, agr = "constant")

tracts_spatial_join <- st_join(demographic_data_tracts_sf, pbe, join = st_intersects) 

tracts_school_count <- tracts_spatial_join %>%
  drop_na(school_name) %>%
  group_by(geoid) %>%
  summarise(schools = n(),
            median_pbe_rate_tract = median(pbe_rate),
            weighted_mean_pbe_rate_tract = weighted.mean(pbe_rate, enroll_tot), # mean pbe rate weighted by total enrollment, giving more sway to larger schools in the model
            enroll_tot_tract = sum(enroll_tot),
            pbe_tot_tract = sum(pbe_tot))

demographic_and_pbe_data_tract <- demographic_data_tracts_sf %>%
  left_join(st_set_geometry(tracts_school_count, NULL))

save(pbe, demographic_data_tracts_sf, points_spatial_join, tracts_spatial_join, demographic_and_pbe_data_tract, file = "data/04_spatial_joins.RData")



