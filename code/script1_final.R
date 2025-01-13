# SCRIPT 1: Merging & Writing new data object


# Setting up working space ------------------------------------------------

rm(list=ls())
setwd("C:/Users/Nadia/Desktop/NYUAD/Brightspace/Soph/Fall/Data Analysis/Final Project")


# Libraries ---------------------------------------------------------------

library(readxl)
library(tidyverse)
library(countrycode)


# Importing data ----------------------------------------------------------

dem_index = read.csv('raw data/DemocracyIndex_EIU_2006_22.csv')

indicators = read.csv('raw data/WorldBankIndicators_2021_22.csv')

spotify = read.csv('raw data/SpotifyData_2021_22.csv')


# Preparing data ----------------------------------------------------------

## create new columns ----
# aggregate weekly spotify data to represent that whole year
spotify = spotify %>%
  mutate(
    year = str_extract(
      spotify$week,
      ".*(?=...-)" # everything before first -
    )
  )

# spotify$region %>% unique()
# spotify$language %>% unique()

## select variables of interest ----
spotify = select(spotify,
                 c("country", # name
                   #"region",
                   "year",
                   "artist_genre",
                   "language")
)

dem_index = dem_index %>%
  select(-c(Entity))

#indicators$Series.Name %>% unique()

indicators = indicators %>%
  subset(Series.Name == "Individuals using the Internet (% of population)" |
           Series.Name == "Literacy rate, adult total (% of people ages 15 and above)" |
           Series.Name == "Lower secondary completion rate, total (% of relevant age group)" |
           Series.Name == "Population ages 0-14 (% of total population)" |
           Series.Name == "Urban population (% of total population)" |
           Series.Name == "GDP per capita (current US$)" |
           Series.Name == "Gini index" |
           Series.Name == "Literacy rate, youth total (% of people ages 15-24)" |
           Series.Name == "Age dependency ratio, young (% of working-age population)") %>%
  select(-c(Series.Code, Country.Name))


## limiting focus years ----
# to only those covered by spotify data

dem_index = subset(dem_index,
                   Year>=2021 & Year<=2022)                                            


## proper data frame format ----
# WB not in proper data frame format that MM and Nelda are in

# pivot from wide to long format
indicators = indicators %>%
  pivot_longer(
    # rename 'year' column
    cols = starts_with('X'),
    names_to = "year",
    names_prefix = "X"
  )

# pivot again to get military expenditure (dependent variable) to be last column
indicators = indicators %>%
  na.omit(df) %>%
  pivot_wider(
    names_from = 'Series.Name',
    values_from = 'value'
  )

# keep only integer part of year
indicators$year = str_extract(
  indicators$year,
  ".*(?=..YR)" # everything before "..YR"
)


## renaming variables ----
# to be easier to follow

spotify = rename(spotify,
                 genre = artist_genre)


dem_index = rename(dem_index,
                   dem_index = democracy_eiu,
                   iso3 = Code,
                   year = Year)

indicators = rename(indicators,
                    internet_pen = `Individuals using the Internet (% of population)`,
                    sec_comp = `Lower secondary completion rate, total (% of relevant age group)`,
                    litrate_15 = `Literacy rate, adult total (% of people ages 15 and above)`,
                    youth_pop = `Population ages 0-14 (% of total population)`,
                    urban_pop = `Urban population (% of total population)`,
                    gdppc = `GDP per capita (current US$)`,
                    gini = `Gini index`,
                    lit_rate = `Literacy rate, youth total (% of people ages 15-24)`,
                    youth_dep_ratio = `Age dependency ratio, young (% of working-age population)`,
                    iso3 = Country.Code)

#indicators$internet_pen %>% is.na() %>% sum


## consistent variable types ----
# variables have to be in quantified forms to undergo calculations

# spotify %>% summary()
# dem_index %>% summary()
# indicators %>% summary()


indicators = indicators %>% 
  mutate(
    year = as.integer(year),
    sec_comp = as.numeric(sec_comp),
    litrate_15 = as.numeric(litrate_15),
    internet_pen = as.numeric(internet_pen), # keep decimal points
    youth_pop = as.numeric(youth_pop),
    gdppc = as.numeric(gdppc),
    urban_pop = as.numeric(urban_pop),
    gini = as.numeric(gini),
    youth_dep_ratio = as.numeric(youth_dep_ratio),
    lit_rate = as.numeric(lit_rate)
  )

spotify = spotify %>%
  mutate(
    year = as.integer(year)
  )

## unifying country code ----

# World Data Bank uses iso3
# EIU's dem_index also uses iso3
# however, spotify data from kaggle doesn't come with any country code

# country-name dictionary that translates many possible variations of country spelling to a standardized version
countryname_dictionary = countrycode::countryname_dict
spotify = unique(spotify)

# first, see whether the name of the country is written "right"
spotify$indicator = ifelse(
  spotify$country
  %in%
    unique(countryname_dictionary$country.name.en),
  1, 0)

# then cross-reference names in your data set with the names in the dictionary
left_join(spotify, countryname_dictionary,
          by = c('country'='country.name.alt'))

# keep all the right names in the real_name variable
spotify$real_name = ifelse(spotify$indicator == 1,
                           spotify$country,
                           NA)

# add the proper country names in English
spotify = left_join(spotify, countryname_dictionary,
                    by = c('country'='country.name.alt'))

# finalize the real names
spotify$real_name = ifelse(is.na(spotify$real_name),
                           spotify$country.name.en,
                           spotify$real_name)

# We can now translate real names into ISO codes
spotify$iso3 = countrycode(spotify$real_name, "country.name", "iso3c")

# keep only variables we need
spotify = select(spotify, c("iso3", "year", "genre", "language"))


## mathematical manipulation to represent each dependent variable ----

# spotify %>% group_by(iso3, year) %>% unique(spotify$genre)
# spotify$genre %>% unique() %>% group_by(iso3, year)

spotify = spotify %>% group_by(iso3, year) %>%
  summarize(
    # number of genres
    num_genres = length(unique(genre))
  )


# Merging data ------------------------------------------------------------

## missing unique identifiers ----

# spotify$iso3 %>% is.na() %>% sum() #8
# spotify$year %>% is.na() %>% sum() #1
#
# indicators$iso3 %>% is.na() %>% sum() #0
# indicators$year %>% is.na() %>% sum() #0
#
# dem_index$iso3 %>% is.na() %>% sum() #0
# dem_index$year %>% is.na() %>% sum() #0

# remove all observations with missing identifiers
spotify = subset(spotify, !is.na(iso3))
spotify = subset(spotify, !is.na(year))


## create panel ----
# contains info from all 3 data sets

# left join indicators and dem_index datasets (dependent and control variables)
# to Spotify (main independent variable)
dat = left_join(spotify, indicators,
                by = c('iso3',
                       'year'))

dat = left_join(dat, dem_index,
                by = c('iso3',
                       'year'))
# number of observations final panel = observations initially in spotify = 139 (didn't change)
# unit of analysis: country-years where spotify data was recorded


## categorize by region ---------------------------------------------------

dat = dat %>% mutate(
  # 7 Regions as defined in the World Bank Development Indicators
  region = countrycode(iso3, "iso3c", "region")
)

#dat %>% summary()


# Write new data object ---------------------------------------------------
# We can now write the data file and save it in the working directory.
write.csv(dat, 'merged_data.csv',
          row.names=F)
