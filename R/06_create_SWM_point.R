library(spdep)
library(sp)
library(tidyverse)
library(sf)
library(raster)

load("data/04_spatial_joins.RData")

utm11N_ESPG <- 26911
points_spatial_join <- points_spatial_join %>%
  st_set_geometry(NULL) %>%
  st_as_sf(coords = c("lon_dec", "lat_dec"), 
                   crs = utm11N_ESPG, agr = "constant")

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



dist_matrix <- pointDistance(p1 = point_coords, lonlat = TRUE) # create matrix of distances between all of the points (upper triangle part is NA, symmetrical matrix about the diagonal)

idw_weights <- round(1/dist_matrix, 4)

idw_weights[!is.finite(idw_weights)] <- NA

saveRDS(idw_weights, file = "data/idw_weights_matrix.RDS")
