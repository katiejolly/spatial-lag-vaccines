# read in the data 

library(tidyverse)
library(janitor)

providers_full <- read_csv("~/health_gis/final_project/raw_data/primary_dataset_providers.csv") 

providers_clean <- clean_names(providers_full) %>%
  filter(state_abbreviation == "CA")

# PCSA data

pcsa_full <- read_csv("~/health_gis/final_project/raw_data/secondary_dataset_pcsa.csv") %>%
  clean_names()

pcsa_clean <- pcsa_full %>%
  filter(state_abbreviation == "CA")

write_csv(pcsa_clean, "~/health_gis/final_project/final_project_healthGIS/data/pcsa_clean.csv")
