library(tidyverse)
library(sf)
library(janitor)
library(fiftystater)
library(ggpomological)



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
  coord_sf() + # project it
  theme_pomological_map() # nice background color 

# TODO

# calculate rates
# spatial join points to zip code
# spatial join pcsa to zip code

