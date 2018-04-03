library(tidyverse)
# library(tidycensus)

load("data/01_acs_data.Rdata")

# get all the variables for 2015 in order to create a matching table

v15 <- load_variables(year = 2015, dataset = "acs5")

# median_age_tracts <- median_age_tracts %>%
#   left_join(
#     v15 %>% select(name, label) %>% mutate(name = gsub("E", "", name)), # take the estimate notifier off of the end of the word
#     by = c("variable" = "name")
#   )

translate_variable_names <- function(data) { # function to add more descriptive variable names to the census files. Uses the v15 table as a crosswalk file.
  data <- data %>%
    left_join(
      v15 %>% select(name, lab = label) %>% mutate(name = gsub("E", "", name)),
      by = c("variable" = "name")
    ) %>%
    mutate(lab = str_to_lower(str_replace_all(lab, "\\!!| ", "_")))
}

######################################################

hisp_latino_origin_clean <- translate_variable_names(hisp_latino_origin_tracts)

hisp_latino_origin_est <- hisp_latino_origin_clean  %>% 
  select(-moe) %>% 
  spread(lab, estimate) %>% 
  rename(estimate_total_pop = estimate_total) %>%
  group_by(GEOID) %>%
  summarise(NAME = min(NAME),
            estimate_total_pop_hisp = sum(estimate_total_pop, na.rm = TRUE),
            estimate_total_hispanic_or_latino = sum(estimate_total_hispanic_or_latino, na.rm = TRUE),
            estimate_total_not_hispanic_or_latino = sum(estimate_total_not_hispanic_or_latino, na.rm = TRUE))

hisp_latino_origin_moe <- hisp_latino_origin_clean  %>% 
  select(-estimate) %>% 
  spread(lab, moe) %>% 
  rename(moe_total_pop = estimate_total) %>%
  group_by(GEOID) %>%
  summarise(
            moe_total_pop_hisp = sum(moe_total_pop, na.rm = TRUE),
            moe_total_hispanic_or_latino = sum(estimate_total_hispanic_or_latino, na.rm = TRUE),
            moe_total_not_hispanic_or_latino = sum(estimate_total_not_hispanic_or_latino, na.rm = TRUE))

hisp_latino_origin_clean <- hisp_latino_origin_est %>%
  left_join(hisp_latino_origin_moe, by = "GEOID")

#################################################

education_attain_tracts_clean <- translate_variable_names(education_attain_tracts)

education_attain_tracts_est <- education_attain_tracts_clean %>% 
  select(-moe) %>% 
  spread(lab, estimate) %>%
  select(1:3, 4:5, 19:20, 27) %>%
  group_by(GEOID) %>%
  summarise(NAME = min(NAME),
            estimate_total_pop_educ = sum(estimate_total, na.rm = TRUE),
            estimate_total_bachelor_degree = sum(`estimate_total_bachelor's_degree`, na.rm = TRUE),
            estimate_total_doctorate_degree = sum(estimate_total_doctorate_degree, na.rm = TRUE),
            estimate_hs_diploma = sum(estimate_total_regular_high_school_diploma, na.rm = TRUE))

education_attain_tracts_moe <- education_attain_tracts_clean %>%
  select(-estimate) %>%
  spread(lab, moe) %>%
  select(1:3, 4:5, 19:20, 27) %>%
  group_by(GEOID) %>%
  summarise(
            moe_total_pop_educ = sum(estimate_total, na.rm = TRUE),
            moe_total_bachelor_degree = sum(`estimate_total_bachelor's_degree`, na.rm = TRUE),
            moe_total_doctorate_degree = sum(estimate_total_doctorate_degree, na.rm = TRUE),
            moe_hs_diploma = sum(estimate_total_regular_high_school_diploma, na.rm = TRUE))

education_attain_tracts_clean <- education_attain_tracts_est %>%
  left_join(education_attain_tracts_moe)

###################################################

places_of_interest <- c("estimate_total_oceania", "estimate_total_europe", "estimate_total_asia", "estimate_total_americas_latin_america", "estimate_total_americas", "estimate_total_africa", "estimate_total")

foreign_born_tracts_clean <- translate_variable_names(foreign_born_tracts) %>%
  filter(lab %in% places_of_interest)

foreign_born_tracts_est <- foreign_born_tracts_clean %>%
  select(-moe) %>%
  spread(lab, estimate) %>%
  group_by(GEOID) %>%
  summarise(NAME = min(NAME),
            estimate_total_foreign_born = sum(estimate_total, na.rm = TRUE),
            estimate_total_africa_foreign_born = sum(estimate_total_africa, na.rm = TRUE),
            estimate_total_americas_foreign_born = sum(estimate_total_americas, na.rm = TRUE),
            estimate_total_latin_america_foreign_born = sum(estimate_total_americas_latin_america, na.rm = TRUE),
            estimate_total_europe_foreign_born = sum(estimate_total_europe, na.rm = TRUE),
            estimate_total_oceania_foreign_born = sum(estimate_total_oceania, na.rm = TRUE))

foreign_born_tracts_moe <- foreign_born_tracts_clean %>%
  select(-estimate) %>%
  spread(lab, moe) %>%
  group_by(GEOID) %>%
  summarise(moe_total_foreign_born = sum(estimate_total, na.rm = TRUE),
            moe_total_africa_foreign_born = sum(estimate_total_africa, na.rm = TRUE),
            moe_total_americas_foreign_born = sum(estimate_total_americas, na.rm = TRUE),
            moe_total_latin_america_foreign_born = sum(estimate_total_americas_latin_america, na.rm = TRUE),
            moe_total_europe_foreign_born = sum(estimate_total_europe, na.rm = TRUE),
            moe_total_oceania_foreign_born = sum(estimate_total_oceania, na.rm = TRUE))

foreign_born_tracts_clean <- foreign_born_tracts_est %>%
  left_join(foreign_born_tracts_moe)

############################################## HH median income

HH_median_income_tracts_clean <- HH_median_income_tracts %>%
  rename(estimate_HH_med_income = estimate,
         moe_HH_med_income = moe) %>%
  select(-c(variable, geometry))


############################################# Median age

median_age_tracts_clean <- translate_variable_names(median_age_tracts)


median_age_tracts_est <- median_age_tracts_clean %>%
  select(-moe) %>%
  distinct(GEOID, lab, .keep_all = TRUE) %>%
  spread(lab, estimate) %>%
  group_by(GEOID) %>%
  summarise(NAME = min(NAME),
            estimate_median_age_female = sum(estimate_median_age_female, na.rm = TRUE),
            estimate_median_age_male = sum(estimate_median_age_male, na.rm = TRUE),
            estimate_median_age_total = sum(estimate_median_age_total, na.rm = TRUE))

median_age_tracts_moe <- median_age_tracts_clean %>%
  select(-estimate) %>%
  distinct(GEOID, lab, .keep_all = TRUE) %>%
  spread(lab, moe) %>%
  group_by(GEOID) %>%
  summarise(moe_median_age_female = sum(estimate_median_age_female, na.rm = TRUE),
            moe_median_age_male = sum(estimate_median_age_male, na.rm = TRUE),
            moe_median_age_total = sum(estimate_median_age_total, na.rm = TRUE))

median_age_tracts_clean <- median_age_tracts_est %>%
  left_join(median_age_tracts_moe)

########################################## Race

race_tracts_clean <- translate_variable_names(race_tracts)

race_tracts_est <- race_tracts_clean %>%
  select(-moe) %>%
  spread(lab, estimate) %>%
  group_by(GEOID) %>%
  summarise(NAME = min(NAME),
            estimate_total_race = sum(estimate_total, na.rm = TRUE),
            estimate_total_am_in_ak_native_alone = sum(estimate_total_american_indian_and_alaska_native_alone, na.rm = TRUE),
            estimate_total_asian_alone = sum(estimate_total_asian_alone, na.rm = TRUE),
            estimate_total_black_alone = sum(estimate_total_black_or_african_american_alone, na.rm = TRUE),
            estimate_total_hawaiian_pacific_islander_alone = sum(estimate_total_native_hawaiian_and_other_pacific_islander_alone, na.rm = TRUE),
            estimate_total_other_race_alone = sum(estimate_total_some_other_race_alone, na.rm = TRUE),
            estimate_total_two_or_more_races = sum(estimate_total_two_or_more_races, na.rm = TRUE),
            estimate_total_white_alone = sum(estimate_total_white_alone, na.rm = TRUE))

race_tracts_moe <- race_tracts_clean %>%
  select(-estimate) %>%
  spread(lab, moe) %>%
  group_by(GEOID) %>%
  summarise(moe_total_race = sum(estimate_total, na.rm = TRUE),
            moe_total_am_in_ak_native_alone = sum(estimate_total_american_indian_and_alaska_native_alone, na.rm = TRUE),
            moe_total_asian_alone = sum(estimate_total_asian_alone, na.rm = TRUE),
            moe_total_black_alone = sum(estimate_total_black_or_african_american_alone, na.rm = TRUE),
            moe_total_hawaiian_pacific_islander_alone = sum(estimate_total_native_hawaiian_and_other_pacific_islander_alone, na.rm = TRUE),
            moe_total_other_race_alone = sum(estimate_total_some_other_race_alone, na.rm = TRUE),
            moe_total_two_or_more_races = sum(estimate_total_two_or_more_races, na.rm = TRUE),
            moe_total_white_alone = sum(estimate_total_white_alone, na.rm = TRUE))


race_tracts_clean <- race_tracts_est %>%
  left_join(race_tracts_moe)

########################################

total_pop_tracts_clean <- translate_variable_names(total_pop_tracts)

total_pop_tracts_moe <- total_pop_tracts_clean %>% 
  select(-estimate) %>% 
  spread(lab, moe) %>% 
  rename(moe_total_pop = estimate_total)


total_pop_tracts_estimate <- total_pop_tracts_clean %>% 
  select(-moe) %>% spread(lab, estimate) %>% 
  rename(estimate_total_pop = estimate_total)

total_pop_tracts_clean <- total_pop_tracts_estimate %>%
  select(GEOID, estimate_total_pop) %>%
  left_join(total_pop_tracts_moe, by = "GEOID")

# crosswalk file between GEOID and geometry

cross_geometry <- total_pop_tracts %>%
  select(GEOID, geometry)

# Write all the clean, final tables to a .RData file

save(cross_geometry, education_attain_tracts_clean, foreign_born_tracts_clean, HH_median_income_tracts_clean, hisp_latino_origin_clean, median_age_tracts_clean, race_tracts_clean, total_pop_tracts_clean, file = "data/02_acs_data_clean.RData")
