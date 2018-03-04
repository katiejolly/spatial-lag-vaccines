library(tidyverse)
library(ggthemes)
library(hexbin)
library(fiftystater)

schools_data <- schools_data %>%
  mutate(pbe_rate = (pbetot/enrolltot) * 100)


california_outline <- fifty_states %>%
  filter(id == "california")

basemap <- ggplot() +
  geom_polygon(data = california_outline, aes(x = long, y = lat, group = group), fill = "#efeede") +
  coord_equal() +
  theme_map()


plot <- basemap +
  stat_summary_hex(data = schools_data, aes(x = longitude, 
                                            y = latitute, z = pbe_rate),
                   fun = mean, bins = 70, alpha = 0.7, color = "gray70") +
  scale_fill_distiller(palette = "Spectral", name="Rate per 100 students", 
                       guide = guide_legend( keyheight = unit(2, units = "mm"), keywidth=unit(8, units = "mm"), label.position = "bottom", title.position = 'top', nrow=1) 
  ) +
  ggtitle( "Mean Personal Belief Exemption Rate \n in California Kindergartens" ) +
  theme(
    legend.position = c(0.5, 0.7),
    text = element_text(color = "#22211d"),
    plot.background = element_rect(fill = "#f5f5f2", color = NA), 
    panel.background = element_rect(fill = "#f5f5f2", color = NA), 
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    plot.title = element_text(size= 14, hjust=0.5, color = "#4e4d47", 
                              margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")))


plot

ggsave("hex.png")

