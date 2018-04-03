# Methodology notes for spatial lag modeling

### Variable selection/ACS API calls

* Packages used:
  * `tidycensus`
  * `tidyverse`

* Spatial scale
  * Census tract

* Table IDs for ACS data
  * Median age: B01002
  * Total population: B01003
  * Race: B02001
  * Hispanic/Latino by origin: B03003
  * Foreign born: B05006
  * Educational attainment: B15003
  * HH median income: B19013

General code (structure):

`get_acs(geography = "tract",
         table = x,
         state = "CA",
         geometry = TRUE)`

Saved to `"data/01_acs_data.Rdata"`
Code in `"R/01_get_acs_data.R"`

### Cleaning ACS variables

* Packages used:
  * tidyverse

* Data loaded
  * `"data/01_acs_data.Rdata"`
