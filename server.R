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
library(scales)
library(plotly)

source("sentiment_func.R")
source("sim_function.R")
source("danceability.R")

us_top <- read.csv("data/us_top200.csv", stringsAsFactors = FALSE)
world_top <- read.csv("data/world_charts_1_9_2018.csv", stringsAsFactors = FALSE)
world_top <- world_top %>%
  filter(Region != "global")
world_top <- mutate(world_top, country_name = countrycode(
  world_top$Region,
  "iso2c", "country.name"
))
rep <- read.csv("repetitiveness.csv", stringsAsFactors = FALSE) %>%
  select(Song, Artist, Repetitiveness)
top_2018 <- read.csv("data/top2018.csv", stringsAsFactors = FALSE)

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
  output$rep_table <- renderDataTable({
    datatable(rep, escape = FALSE, options = list(dom = "lrtp"), style = "bootstrap")
  })

  top_by_region <- world_top %>%
    group_by(Region) %>%
    filter(Streams == max(Streams))

  top_world_df <- data.frame(
    top_by_region$country_name, top_by_region$Streams,
    top_by_region$Track.Name, top_by_region$Artist
  )

  output$table <- renderDataTable({
    world_top_table <- datatable(top_world_df,
      colnames = c(
        "Country", "Streams",
        "Title", "Artist"
      ),
      filter = "top", options = list(
        pageLength = 10, autoWidth = TRUE
      ), style = "bootstrap"
    )
  })

  # Artists with most number of streams worldwide
  most_streamed_artist <- reactive({
    world_top %>%
      select(Track.Name, Artist, Streams, country_name) %>%
      group_by(Artist) %>%
      summarize(Streams = sum(Streams)) %>%
      arrange(-Streams) %>%
      head(input$top_num)
  })

  output$streams <- renderPlot({
    bar <- ggplot(most_streamed_artist(), aes(x = reorder(Artist, -Streams), y = Streams)) +
      labs(
        x = "Artist",
        y = "Streams"
      ) + scale_y_continuous(labels = comma) +
      geom_bar(stat = "identity", fill = "#1DB954")
    bar
  })

  # Songs with the most streams worldwide
  songs <- world_top %>%
    select(Track.Name, Artist, Streams, country_name) %>%
    group_by(Track.Name) %>%
    summarize(Streams = sum(Streams)) %>%
    arrange(-Streams)

  most_streamed_song <- reactive({
    songs <- songs %>%
      head(input$top_num)
    songs$Artist <- lapply(songs$Track.Name, artist)
    songs$Track_Artist <- paste(songs$Track.Name, "-", songs$Artist)
    songs
  })

  # Get track artist name
  artist <- function(title) {
    world_top %>%
      select(Track.Name, Artist) %>%
      filter(Track.Name == title) %>%
      head(1) %>%
      select(Artist) %>%
      pull(Artist)
  }

  output$song_streams <- renderPlot({
    bar <- ggplot(most_streamed_song(), aes(x = reorder(Track_Artist, -Streams), y = Streams)) +
      labs(
        x = "Track Name",
        y = "Streams"
      ) + scale_y_continuous(labels = comma) +
      geom_bar(stat = "identity", fill = "#1DB954")
    bar
  })
  output$dance_plot <- renderPlotly({
    danceability_plot <- ggplot(
      data = top_2018,
      mapping = aes_string(
        x = input$x_var, y = "danceability",
        color = "danceability"
      )
    ) +
      geom_point() +
      geom_smooth()
    ggplotly(danceability_plot)
  })
})
