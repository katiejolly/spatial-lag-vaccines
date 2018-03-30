library(tidyverse)
library(sf)
library(snakecase)

load("data/demographic_variables_sf.RData")

utm11N_ESPG <- 26911 # use the utm 11N projection

demographic_data_tracts_sf <- demographic_data_tracts_sf %>%
  st_transform(utm11N_ESPG)

pbe <- read_sf("california_schools_pbe/CA_schools_PBE.shp") %>%
  st_transform(utm11N_ESPG) %>%
  mutate(pbe_rate = PBETot/EnrollTot)

pbe_names <- to_any_case(names(pbe), case = "snake")

names(pbe) <- pbe_names

points_spatial_join <- st_join(demographic_data_tracts_sf, pbe,  join = st_contains) %>%
  drop_na(Name)

tracts_spatial_join <- st_join(demographic_data_tracts_sf, pbe, join = st_intersects)



