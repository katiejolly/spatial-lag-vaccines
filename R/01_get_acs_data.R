library(tidyverse)
library(tidycensus)

# this script loads the necessary detailed ACS files. The default endyear is 2015. If running this script on a device that hasn't used tidycensus, you may
# need to install an API key. More information about tidycensus is available at https://github.com/walkerke/tidycensus

# last run 29 March 2018

# all data is for California census tracts

median_age_tracts <- get_acs(geography = "tract",
                             table = "B01002",
                             state = "CA",
                             geometry = TRUE)

total_pop_tracts <- get_acs(geography = "tract",
                            table = "B01003",
                            state = "CA",
                            geometry = TRUE)

race_tracts <- get_acs(geography = "tract",
                       table = "B02001",
                       state = "CA",
                       geometry = TRUE)

hisp_latino_origin_tracts <- get_acs(geography = "tract",
                                     table = "B03003",
                                     state = "CA",
                                     geometry = TRUE)

foreign_born_tracts <- get_acs(geography = "tract",
                               table = "B05006", # check this table, I'm not sure it's the right one to use
                               state = "CA",
                               geometry = TRUE)

education_attain_tracts <- get_acs(geography = "tract",
                                   table = "B15003",
                                   state = "CA",
                                   geometry = TRUE)

HH_median_income_tracts <- get_acs(geography = "tract",
                                   table = "B19013",
                                   state = "CA",
                                   geometry = TRUE)

# save all the files to one RData file for easy loading next time

save(education_attain_tracts, foreign_born_tracts, HH_median_income_tracts, hisp_latino_origin_tracts, median_age_tracts, race_tracts, total_pop_tracts, file = "data/01_acs_data.RData")

