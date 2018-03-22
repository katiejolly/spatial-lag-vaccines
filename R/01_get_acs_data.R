library(tidyverse)
library(tidycensus)

vars <- c("B03001_003E", "B03001_003M", # total hispanic population
          "B01001_001E", "B01001_001M", # total population
          "B03001_004E", "B03001_004M", # mexican 
          "B03001_005E", "B03001_005M", # puerto rican
          "B03001_008E", "B03001_008M", # central american
          "B03001_016E", "B03001_016M", # south american
          )
race_ca_tracts <- get_acs(geography = "tract",
                          state = "CA",
                          table = "B02001",
                          year = 2016)
