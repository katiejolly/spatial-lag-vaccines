schools_data <- schools_data %>%
  mutate(pbe_rate = (pbetot/enrolltot) * 100)


california_outline <- fifty_states %>%
  filter(id == "california")

basemap <- ggplot() +
  geom_polygon(data = california_outline, aes(x = long, y = lat, group = group), fill = "#efeede") +
  coord_equal() +
  theme_map()

plot <- basemap +
  stat_density2d(data=stops, show.legend=F, 
                 aes(x=InterventionLocationLongitude, 
                     y=InterventionLocationLatitude, 
                     fill=..level.., alpha=..level..), geom="polygon", size=2, bins=10)
  



gg <- ggplot()
gg <- gg + stat_density2d(data=stops, show.legend=F, aes(x=InterventionLocationLongitude, y=InterventionLocationLatitude, fill=..level.., alpha=..level..), geom="polygon", size=2, bins=10)
gg <- gg + geom_polygon(data=towntracts, aes(x=long, y=lat, group=group, fill=NA), color = "black", fill=NA, size=0.5) 
gg <- gg + scale_fill_gradient(low="deepskyblue2", high="firebrick1", name="Distribution")
gg <- gg +  coord_map("polyconic", xlim=c(-73.067649, -72.743739), ylim=c(41.280972, 41.485011)) 
gg <- gg + labs(x=NULL, y=NULL, 
                title="Traffic stops distribution in Hamden",
                subtitle=NULL,
                caption="Source: data.ct.gov")
gg