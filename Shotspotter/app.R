# Load packages

library(shiny)
library(tidyverse)
library(tidycensus)
library(ggplot2)
library(sf)
library(tigris)
library(gganimate)
library(ggthemes)


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

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Gunfire Incidents at Washington D.C. Through the Years"),
  
  # Application theme
  theme = shinytheme("slate"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      width = 5,
      includeMarkdown("sidepanel.md")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      width = 7
    )
  ),
  imageOutput("plot1")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$plot1 <- renderImage({
    # generate bins based on input$bins from ui.R
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
    
  }, deleteFile = TRUE)
}

# Run the application 
shinyApp(ui = ui, server = server)