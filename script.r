# Load packages

library(shiny)
library(tidyverse)
library(tidycensus)
library(ggplot2)
library(sf)
library(tigris)
library(gganimate)
library(ggthemes)

# Load data set for Washington D.C., specifying the types of its columns
# according to the inferred types.

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

# Using get_acs function, we get the simple feature file for city Washington DC.

dc_sf <- get_acs(
  geography = "tract", variables = "B19013_001",
  state = "DC", geometry = TRUE
)

# Refactoring type, so that in the plot, the type is displayed in a human
# readable form.

washington_dc <- washington_dc %>% 
  mutate(type = factor(type, labels = c("Multiple Gunshots", "Single Gunshot", "Gunshot or Firecracker"),
                       levels = c("Multiple_Gunshots", "Single_Gunshot", "Gunshot_or_Firecracker"))) %>% 
  
  # Filter out the rows in which types are NA.
  
  filter(!is.na(type))

ggplot() +
  
  # Create a base layer plot for Washington D.C.'s map.
  
  geom_sf(data = dc_sf) +
  
  # Create another layer that plots out the points in which type is not null.
  
  geom_point(data = washington_dc, aes(x = longitude, y = latitude, alpha = 0.1, color = type)) +
  
  # Animate the graph and use time to specify transition state. We don't want
  # moving points. Therefore, we specify transition_length to be zero.
  
  transition_states(year, transition_length = 0) +
  labs(title = "Gunfire Incidents in Washington D.C. in {closest_state}",
       color = "Types of Gunshot",
       x = NULL,
       y = NULL,
       caption = "Shotspotter/Justice Tech Lab") +
  scale_alpha(guide = "none") +
  
  # Because the default background of the Shiny app is white, we use minimal
  # theme to make the graph fit the Shiny app.

  theme_minimal() +
    
  # Spatial coordinates on the scales are unnecessary. Disabling them.
    
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

anim_save("Shotspotter/washington_dc_distribution.gif")

anim_save("outfile.gif", animate(p))

# Return list containing filename
list(src = "outfile.gif",
     contentType = "image/gif")

deleteFile = TRUE