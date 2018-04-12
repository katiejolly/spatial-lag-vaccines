library(tidyverse)
library(spdep)
library(ape)

here::here()

load("data/06_idw_weights.RData")

load("data/04_spatial_joins.RData")

points_spatial_join <- points_spatial_join %>%
  mutate(
  )
