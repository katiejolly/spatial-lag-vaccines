library(tidyverse)
library(spdep)
library(ape)

here::here()

load("data/06_idw_weights.RData")

load("data/04_spatial_joins.RData")


moran <- moran.mc(points_spatial_join$pbe_rate, idw_matrix, nsim = 99)

idw_matrix_subset <- ifelse(idw_matrix$weights < 0.0001, 0, idw_matrix$weights)

moran.test(points_spatial_join$pbe_rate, idw_matrix$weights)
