# server.R
library(shiny)
library(ggplot2)
library(dplyr)
library(lintr)
library(genius)
library(tidyverse)
library(songsim)
library(syuzhet)

source("sentiment_func.R")
source("sim_function.R")

us_top <- read.csv("data/us_top200.csv", stringsAsFactors = FALSE)

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
})