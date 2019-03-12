# ui.R
library(shiny)
library(ggplot2)
library(dplyr)
library(lintr)
library(genius)
library(tidyverse)
library(songsim)
library(syuzhet)

us_top <- read.csv("data/us_top200.csv", stringsAsFactors = FALSE)
us_top <- us_top[order(us_top$Track.Name),]

world_top <- read.csv("data/world_charts_1_9_2018.csv", stringsAsFactors = FALSE)

shinyUI(navbarPage(
  "Analyzing Music",
  mainPanel(
    # home page
    h1("Analyzing Music"),
    h3("About the Project"),
    h3("Findings"),
    h3("About Us")
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
        h2("SongSim Matrix"),
        plotOutput("sim_plot"),
        h2("Mood Graph"),
        plotOutput("mood_graph"),
        h3("SongSim Explanation"),
        p("A SongSim Matrix is a particular way to visualize a song.
          In particular, it demonstrates how repetitive song lyrics are.
          To get the lyrics in the first place, the ",
          a("R genius package",
            href = "https://cran.r-project.org/web/packages/genius/index.html"),
          " is used to get lyrics from the lyrics website Genius. These lyrics are put
          into a text file that gets processed by the ",
          a("R songsim package", href = "https://github.com/gsimchoni/songsim"),
          ", producing a self-similarity matrix. Different shapes have different
          representations: "),
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
        p("The matrix has an option to show color, and with color,
          a black square on the matrix means the word appears only once in
          the matrix, so most verses are black. A broken diagonal is
          representative of a verse similar to the chorus."),
        h3("Mood Graph Explanation")
        )
        )
        ),
  tabPanel(
    "Table Analysis",
    titlePanel("Top Song in each Country"),
    fluidPage(
        dataTableOutput("table")

    )
  ),
  tabPanel(
    "About Us",
    titlePanel(strong("ABOUT US")),
      mainPanel(
        h2("Who We Are", align = "center"),
        h3("We are Team Starfish from Info 201 Section BE", align = "center"),
        br(),
        h4("Meet Team Members:")
      )
    
  )
)
)
