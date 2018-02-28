library(viridis)

head(ca_schools_tract_join)

ca_pbe_tract <- ca_schools_tract_join %>%
  group_by(TRACTCE, GEOID) %>%
  summarise(schools = n(),
            median_pbe = median(pbe_rate, na.rm = TRUE))

ca_pbe_tract_poly <- ca_tracts %>%
  geo_join(ca_pbe_tract, by = c("GEOID")) %>%
  sf::st_as_sf()

ggplot(ca_pbe_tract_poly) +
  geom_sf(aes(fill = median_pbe)) +
  scale_fill_viridis() 
