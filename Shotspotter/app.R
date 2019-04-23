# Load packages

library(shiny)
library(tidyverse)
library(tidycensus)
library(ggplot2)
library(sf)
library(tigris)
library(gganimate)
library(ggthemes)
library(shinythemes)

# Define the UI for this Shiny Application
ui <- fluidPage(
  
  # Application title
  titlePanel("Gunfire Incidents at Washington D.C. Through the Years"),
  
  # Application theme
  # theme = shinytheme("slate"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      # Change the width to 5 so that the Markdown file have more space to be
      # displayed
      
      width = 5,
      
      # Include the markdown file to render text more conveniently.
      
      includeMarkdown("sidepanel.md")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      width = 7,
      imageOutput("plot1")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # To reduce the loading time, we render the pre-rendered gif under the
  # server's directory.
  
  output$plot1 <- renderImage({list(src = "washington_dc_distribution.gif",
                                    contentType = "image/gif")}, 
                              deleteFile = FALSE)
  
  } 

# Run the application 
shinyApp(ui = ui, server = server)