library(spdep)
library(sp)
library(tidyverse)
library(sf)
library(raster)

options(scipen = 999)

load("data/04_spatial_joins.RData")

utm11N_ESPG <- 26911
# points_spatial_join <- points_spatial_join %>%
#   st_set_geometry(NULL) %>%
#   st_as_sf(coords = c("lon_dec", "lat_dec"), 
#                    crs = utm11N_ESPG, agr = "constant")

ggplot(data = points_spatial_join) +
  geom_sf()

point_coords <- st_coordinates(points_spatial_join)

# dis <- 50
# 
# y <- dnearneigh(point_coords, 0, dis)
# 
# swm_100k <- y
# 
# listw_100k <- nb2listw(swm_100k)
# 
# moran_100k <- moran.mc(points_spatial_join$pbe_rate, listw_100k, nsim = 99)
# 
# moran_100k

# I think I have a better way of calculating distance-based matrices

points_spatial_join_log <- points_spatial_join %>%
  filter(pbe_rate != 0) %>%
  mutate(log_pbe_rate = log(pbe_rate * 100)) # only schools with rate above zero

point_coords <- st_coordinates(points_spatial_join_log)



dist_matrix <- pointDistance(p1 = point_coords, lonlat = TRUE) # create matrix of distances between all of the points (upper triangle part is NA, symmetrical matrix about the diagonal)

dist_matrix[upper.tri(dist_matrix)] = t(dist_matrix)[upper.tri(dist_matrix)] # make the upper triangle part symmetric to the lower

for(i in 1:dim(dist_matrix)[1]) {dist_matrix[i,i] = 0} # assign 0 to diagonal values 

idw_dist_matrix <- ifelse(dist_matrix!=0, round(1/dist_matrix, 6), dist_matrix) # inverse unless 0, round to 6 decimal places

idw_matrix <- mat2listw(idw_dist_matrix, style = "W") # still needs to run- takes a long time

# took about 1 hour 

#save(idw_matrix, idw_dist_matrix, dist_matrix, file = "data/06_idw_weights.RData") # includes zero rates

save(idw_matrix, idw_dist_matrix, dist_matrix, file = "data/06_idw_weights2.RData") # does not include zero rates
