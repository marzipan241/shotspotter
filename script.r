# Comments

library(shiny)
library(tidyverse)
library(tidycensus)
library(ggplot2)
library(sf)


x <- read_csv("http://justicetechlab.org/wp-content/uploads/2018/05/washington_dc_2006to2017.csv",
              cols(
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
                type = col_logical()
              ))