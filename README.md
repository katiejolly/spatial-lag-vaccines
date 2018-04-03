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
         geometry = TRUE)` # gets data for a particular table in all California census tracts. geometry = TRUE allows us to plot with sf

Data in `"data/01_acs_data.Rdata"`

Code in `"R/01_get_acs_data.R"`

### Cleaning ACS variables

* Packages used:
  * tidyverse

* Data loaded
  * `"data/01_acs_data.Rdata"`

First, I needed to translate variable names from their encoding to the actual words.

I wrote a function for that (it allows formats them to eventually be variable names)

`translate_variable_names <- function(data) { # function to add more descriptive variable names to the census files. Uses the v15 table as a crosswalk file.

  data <- data %>%

    left_join(

      v15 %>% select(name, lab = label) %>% mutate(name = gsub("E", "", name)),

      by = c("variable" = "name")

    ) %>%

    mutate(lab = str_to_lower(str_replace_all(lab, "\\!!| ", "_")))

}`

Then for each tract I found the estimate and MOE for all of my variables of interest from each table. I'm sure there's a better way to do this. I'd like to eventually make this a function. Violates DRY quite a few times...

Saved to `"data/02_acs_data_clean.RData"`

Code in `"R/02_clean_acs_data.R"`

### Join into one master table of variables

Includes sf-ready version of all covariates from the ACS

Code in `"R/03_join_acs_data.R"`

Data in `"data/03_demographic_variables_sf.RData"`

### Aggregation + spatial joins

* Packages used
  * sf
  * snakecase
  * tidyverse

Used UTM 11N projections
* ESPG: 26911 (NAD83)
* [source: spatialreference.org](http://spatialreference.org/ref/epsg/nad83-utm-zone-11n/)

Read in the data for PBE information at the school (point) scale using `sf`

Attached demographic variables (tract scale) to school points in `points_spatial_join`

Found number of schools per census tract in `tracts_school_count`

Then I attached the school number per census tract (`schools`) as well as information about total enrollment, weighted mean PBE rate by enrollment total, and total personal belief exemptions in the `demographic_and_pbe_data_tract` table.

Code in `"R/04_aggregate_PBE.R"`

Data in `"data/04_spatial_joins.RData"`

### Create the spatial weights matrix

* Packages used
  * spdep
  * sp
  * sf
  * tidyverse
  * raster

Initially, I wanted to use a distance-based nearest neighbor approach. But that doesn't really make sense in the context of this data. A school that is 100km away doesn't have the same influence as a school that is 10km away. Instead, I chose to use inverse distance weighting to assign spatial weights.

Instead of selecting points within a buffer of each other buffer, I calculated a weight for each point. (The weights matrix is symmetric about the diagonal. While it would make more sense for only one half of the matrix to be filled in, other functions require no NA values.)

This gave me a square 6469 x 6469 (the number of schools in my dataset) distance matrix in meters.

![snapshot of the matrix](images/dist_matrix.JPG)

I then inverted the values to get the inverse distance weightings. I rounded the values to 6 decimal places
