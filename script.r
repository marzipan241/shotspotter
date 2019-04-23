# Load packages

library(shiny)
library(tidyverse)
library(tidycensus)
library(ggplot2)
library(sf)
library(tigris)
library(gganimate)
library(ggthemes)

# Load data set

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
                          )) 


# Create a temporary file to save the output

outfile <- tempfile(fileext = ".gif")

# Create the animation

washington_dc %>% 
  filter(!is.na(type))

dc_sf <- get_acs(
  geography = "tract", variables = "B19013_001",
  state = "DC", geometry = TRUE
)

urban_areas(class = "sf")
    
p = ggplot() +
  geom_sf(data = dc_sf) +
  geom_point(data = washington_dc, aes(x = longitude, y = latitude, alpha = 0.1, color = type)) +
  transition_states(year, transition_length = 0) +
  labs(title = "{closest_state}") +
  theme_map()

anim_save("outfile.gif", animate(p))

# Return list containing filename
list(src = "outfile.gif",
     contentType = "image/gif")

deleteFile = TRUE