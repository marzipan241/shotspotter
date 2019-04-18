# Comments

library(shiny)
library(tidyverse)
library(tidycensus)
library(ggplot2)
library(sf)
library(tigris)
library(gganimate)


washington_dc <- read_csv("http://justicetechlab.org/wp-content/uploads/2018/05/washington_dc_2006to2017.csv",
  col_types = cols(
    incidentid = col_double(),
    latitude = col_double(),
    longitude = col_double(),
    year = col_double(),
    month = col_double(),
    day = col_double(),
    hour = col_double(),
    minute = col_double(),
    second = col_double(),
    numshots = col_double(),
    type = col_factor()
  )
) %>% 
  filter(!is.na(type))


dc_sf <- get_acs(
  geography = "tract", variables = "B19013_001",
  state = "DC", geometry = TRUE
)

urban_areas(class = "sf")

ggplot() +
  geom_sf(data = dc_sf) +
  geom_point(data = washington_dc, aes(x = longitude, y = latitude, alpha = 0.1, color = type)) +
  transition_states(year, transition_length = 0)
