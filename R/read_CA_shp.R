library(tidyverse)
library(sf)
library(janitor)
library(fiftystater)
library(ggpomological)
library(tigris)



ca_schools <- st_read("california_schools_pbe/CA_schools_PBE.shp") %>%
  clean_names() # read in the California data

california_background <- fifty_states %>%
  filter(id == "california") # make a background map of California

ggplot() +
  geom_polygon(data = california_background, 
               aes(x = long, y = lat, group = group),
               fill = "#e68c7c") + # plot the basemap
  geom_sf(data = ca_schools, 
          color = "#4f5157", 
          alpha = 0.6) + # add the schools point layer
  coord_sf() 

# TODO

# calculate rates

ca_schools <- ca_schools %>%
  mutate(pbe_rate = pbetot/enrolltot)

# spatial join points to census tract

ca_tracts <- tigris::tracts(state = "CA")
ca_tracts_sf <- st_as_sf(ca_tracts)
ca_tracts_sf_transform <- st_transform(ca_tracts_sf, "+proj=longlat +datum=WGS84 +no_defs") # set coordinate reference system

ca_schools_tract_join <- st_join(ca_schools, ca_tracts_sf_transform) # spatial join points to polygons

# spatial join pcsa to zip code

