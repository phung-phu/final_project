# server.R
library(shiny)
library(ggplot2)
library(dplyr)
library(lintr)
library(genius)
library(tidyverse)
library(songsim)
library(syuzhet)
library(countrycode)
library(DT)

source("sentiment_func.R")
source("sim_function.R")

us_top <- read.csv("data/us_top200.csv", stringsAsFactors = FALSE)
world_top <- read.csv("data/world_charts_1_9_2018.csv", stringsAsFactors = FALSE)
world_top <- world_top %>%
  filter(Region != "global")
world_top <- mutate(world_top, country_name = countrycode(world_top$Region, 
                                                          "iso2c", "country.name"))

shinyServer(function(input, output) {
  output$sim_plot <- renderPlot({
    filtered <- us_top %>%
      filter(Track.Name == input$selSong)
    artist_name <- filtered$Artist
    song_name <- filtered$Track.Name
    sim_p <- find_sim(artist_name, song_name)
    sim_p
  })
  output$mood_graph <- renderPlot({
    find_song <- us_top %>%
      filter(Track.Name == input$selSong)
    artist_name <- find_song$Artist
    song_name <- find_song$Track.Name
    sen <- get_sent(artist_name, song_name)
    get_graph(sen)
  })

  top_by_region <- world_top %>%
    group_by(Region) %>%
    filter(Streams == max(Streams))
  
  top_world_df <- data.frame(top_by_region$country_name, top_by_region$Streams, 
                             top_by_region$Track.Name, top_by_region$Artist)

  output$table <- renderDataTable({
    world_top_table <- datatable(top_world_df,
      colnames = c(
        "Country", "Streams",
        "Title", "Artist"
      ),
      filter = "top", options = list(
        pageLength = 10, autoWidth = TRUE
      )
    )
  })
})
