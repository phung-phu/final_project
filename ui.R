# ui.R
library(shiny)
library(ggplot2)
library(dplyr)
library(lintr)
library(genius)
library(tidyverse)
library(songsim)
library(plotly)
library(syuzhet)
library(DT)
library(shinythemes)

source("sim_function.R")
source("text.R")

us_top <- read.csv("data/us_top200.csv", stringsAsFactors = FALSE)
us_top <- us_top[order(us_top$Track.Name), ]

world_top <- read.csv("data/world_charts_1_9_2018.csv",
                      stringsAsFactors = FALSE)

shinyUI(fluidPage(
  includeCSS("style.css"),
  theme = shinytheme("cyborg"),
  navbarPage(
  "Analyzing Music",
  tabPanel(
    "About the Project",
    mainPanel(
      tags$hr(),
      h3("Project Description - What Questions Do We Hope to Answer?",
         align = "center"),
      tags$hr(),
      h4("What are some general characteristics of popular music?"),
      p(proj_descrip),
      br(),
      h4("What music is popular in different countries?"),
      p(diff_countries),
      br(),
      h4("What makes music popular?"),
      p(music_pop),
      p(dance),
      br(),
      tags$hr(),
      h3("Our Data", align = "center"),
      tags$hr(),
      about_data,
      br(),
      tags$hr(),
      h3("Technical Description", align = "center"),
      tags$hr(),
      tech_descrip_1,
      tech_descrip_2
    )
  ),
  tabPanel(
    "Individual Song Analysis",
    titlePanel("Repetition and Mood in Chart Toppers"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "selSong",
          label = "Select a song from the US Top 200 on 1/9/18: ",
          choices = us_top$Track.Name
        )
      ),
      mainPanel(
        tags$hr(),
        h2("SongSim Matrix", align = "center"),
        tags$hr(),
        plotOutput("sim_plot"),
        tags$hr(),
        h2("Mood Graph", align = "center"),
        tags$hr(),
        plotOutput("mood_graph"),
        br(),
        h3("SongSim Explanation"),
        song_sim,
        h4("Long Diagonals"),
        img(src = "long_diagonals.png", height = 250, width = 250),
        p("Long diagonals look like lines stretching across the matrix,
          often representing the chorus or something similarly repeated."),
        h4("Stripey Squares"),
        img(src = "stripey_square.png", height = 250, width = 250),
        p("Stripey squares represent repeated sections within another repeated
          section, such as when a chorus is often repeated."),
        h6("Checkerboards"),
        img(src = "checkerboard.png", height = 250, width = 250),
        p("Checkerboards are a certain kind of stripey squares, where only two
          words are being repeated over and over again."),
        h6("Filled Blocks"),
        img(src = "filled_in_blocks.png", height = 250, width = 250),
        p("Similar to checkerboards, filled blocks are a type of stripey
          squares, but only one word is being repeated."),
        h4("Broken Diagonals"),
        img(src = "broken_diagonals.png", height = 250, width = 250),
        matrix,
        h4("Colors"),
        p("Each different color represents a new distinct word in the song."),
        h4("Repetitiveness"),
        rep,
        h3("Patterns Seen"),
        pattern,
        br(),
        tags$hr(),
        h2("Repetitiveness in US Top 200 on 1/9/18", align = "center"),
        tags$hr(),
        dataTableOutput("rep_table"),
        br(),
        h3("Mood Graph Explanation"),
        lyrics
        )
        )
    ),
  tabPanel(
    "Table and Plot Analysis",
    tags$div(class = "background"),
    tags$hr(),
    h3("Top Song in each Country", align = "center"),
    tags$hr(),
    fluidPage(
      dataTableOutput("table"),
      p(countries),
      br(),
      tags$hr(),
      h3("Which Artists and Songs were streamed the most?", align = "center"),
      tags$hr(),
      br(),
      numericInput(
        "top_num",
        label = "Enter the number of artists/songs you wish to view",
        value = 5
      ),
      h4("Which Artists were streamed the most?", align = "center"),
      plotOutput("streams"),
      br(),
      h4("Which Songs had the most streams?", align = "center"),
      plotOutput("song_streams"),
      p(list_artists)
    )
  ),
  tabPanel(
    "Danceability",
    titlePanel("Factors of Danceability"),
    sidebarLayout(
      sidebarPanel(
        selectInput(
          "x_var",
          label = "Select Factor",
          choices = c("energy", "loudness", "speechiness",
                      "acousticness", "valence", "liveness", "tempo")
        )
      ),
      mainPanel(
        plotlyOutput("dance_plot"),
        p("This is an interactive plot where you can select different
          variables and witness the effect this
          has on the 'dancebility' of today's hottest songs. The songs
          used for this dataset are the Top 100 streamed songs of 2018."),
        p(dance_page)
      )
    )
  ),
  tabPanel(
    "About Us",
    titlePanel(strong("ABOUT US")),
    mainPanel(
      h2("Who We Are", align = "center"),
      h3("We are Team Starfish from Info 201 Section BE", align = "center"),
      br(),
      h4("Meet Team Members: Phung Phu, Renee Wang, Xuhua Zou, Kyle Lawrence"),
      br(),
      tags$hr(),
      h4("Phung Phu"),
      p("Phung is a sophomore in Civil Engineering."),
      img(src = "phung.jpg", height = 350, width = 400),
      h4("Renee Wang"),
      p("Renee is a freshman who is interested in majoring in Computer
        or Electrical Engineering. In her spare time, she likes to ride
        horses and listen to music."),
      img(src = "renee.png", height = 350, width = 500),
      h4("Kyle Lawrence"),
      p("Kyle is a senior majoring in Economics."),
      img(src = "kyle.jpg", height = 350, width = 450),
      h4("Xuhua Zou"),
      p("Xuhua is a sophomore who intends to major in Informatics,
        In her spare time, she likes to travel and watch movies."),
      img(src = "xuhua.jpg", height = 350, width = 350)
    )
  )
)))
