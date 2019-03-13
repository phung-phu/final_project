# ui.R
library(shiny)
library(ggplot2)
library(dplyr)
library(lintr)
library(genius)
library(tidyverse)
library(songsim)
library(syuzhet)

source("sim_function.R")

us_top <- read.csv("data/us_top200.csv", stringsAsFactors = FALSE)
us_top <- us_top[order(us_top$Track.Name), ]

world_top <- read.csv("data/world_charts_1_9_2018.csv", stringsAsFactors = FALSE)

shinyUI(navbarPage(
  "Analyzing Music",
  tabPanel(
    "About the Project",
    titlePanel("Project Overview"),
    mainPanel(
      h3("Project Description - What Questions Do We Hope to Answer?"),
      h4("What are some general characteristics of popular music?"),
      p("We answered this question by looking doing some individual song
          analysis. We did this by looking at not just the repetition tendencies
          in songs, but also the moods that their lyrics conveyed. While moods in
          different songs were all over the board and couldn't be summarized, the moods
          in each individual pop song on the US Top 200 on 1/9/2018 can be visualized
          from our project. We also looked at how repeated songs are by creating
          Song Sim Matrices with song lyrics, and while the repetitiveness average
          was relatively low at 1.99%, there are certainly outliers that exceed 
          above 10% repetitiveness."),
      h4("What music is popular in different countries?"),
      p("The popularity of music is widely spreaded, as when viewing table of 
          Top Song in Each Country, we can clearly see that the song name and artist
          shown for each country are mostly different, without much repetition.
          Therefore, we conclude that music popularity is widespread."),
      h4("What makes music popular?"),
      p("Music is overall really popular as displayed on Spotify. We can determine if a song
          is popular by looking at the table analysis, where selecting different countries
          allow you to see corresponding top song lists. Songs appear on a country's
          top lists represent their popularity in that country; if some songs appear
          on the top list for multiple countries, it is an illustration that they are
          in high popularity in specific time among the world."),
      br(),
      h3("Technical Description"),
      p(
        "Beyond ", code("shiny"), " and ", code("dplyr"), " we also used packages like",
        code("genius"), ", ", code("songsim"), ", ",
        code("syuzhet"), ", ", code("countrycode"), ", and ",
        code("DT"), "to complete this project. ", code("genius"),
        " was helpful in particular because it gathered lyrics for each song,
          which we could then do a lot with, such as repetition analysis with ",
        code("songsim"), " and mood analysis with ", code("syuzhet"),
        ". Other packages helped us with wrangling the data and then
          forming data tables."
      ),
      p("Both of our datasets were static ", code(".csv"), " files which
          meant we did not need to use APIs. Statistical analysis are done
          by table analysis of top songs and graphs demonstrating individual
          song analysis.")
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
        h2("SongSim Matrix"),
        plotOutput("sim_plot"),
        h2("Mood Graph"),
        plotOutput("mood_graph"),
        h3("SongSim Explanation"),
        p(
          "A SongSim Matrix is a particular way to visualize a song.
          In particular, it demonstrates how repetitive song lyrics are.
          To get the lyrics in the first place, the ",
          a("R genius package",
            href = "https://cran.r-project.org/web/packages/genius/index.html"
          ),
          " is used to get lyrics from the lyrics website Genius. These lyrics are put
          into a text file that gets processed by the ",
          a("R songsim package", href = "https://github.com/gsimchoni/songsim"),
          ", producing a self-similarity matrix. Different shapes have different
          representations: "
        ),
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
        h4("Colors"),
        p("Each different color represents a new distinct word in the song."),
        h4("Repetitiveness"),
        p("Repetitiveness is simply a way to quantify the matrices formed.
          For every empty cell, there is a value of 0 and for every colored
          in cell, there is a value of 1, so the average would be a decimal
          between 0 and 1. Multiplied by 100, the repetitveness would be a
          percentage, illustrating what percentage of the song is being 
          repeated."),
        h3("Patterns Seen"),
        p("Overall, the average repetitiveness of the songs on the US Top 200
          Chart was found to be 1.99%. This number is relatively low. However,
there are definitetly outliers in this dataset, and individual repetitivness values
          can be seen in the table below. Songs can also be played by clicking on the
          song title in the table."),
        h2("Repetitivenss in US Top 200 1/9/18"),
        dataTableOutput("rep_table"),
        h3("Mood Graph Explanation"),
        p(
          "The mood graph is based on the same lyrics gathered for the SongSim
          Matrix, but uses the ",
          a("syuzhet package",
            href = "https://www.rdocumentation.org/packages/syuzhet/versions/1.0.4"
          ),
          " to perform an ",
          a("nrc analysis",
            href = "http://www.saifmohammad.com/WebPages/NRC-Emotion-Lexicon.htm"
          ),
          " in order to find the moods of the lyrics. For every word in a song that
          falls in one of the 8 emotions the analysis categorizes into (anger, 
          anticipation, disgust, fear, joy, sadness, surprise, trust), a tally is added,
          and these tallies are graphed into the mood graphs seen in this song analysis."
        )
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
    "Plots",
    titlePanel("Which Artists and Songs were streamed the most?"),
    fluidPage(
      numericInput(
        "top_num",
        label = "Enter the number of artists/songs you wish to view",
        value = 5
      ),
      h4("Which Artists were streamed the most?"),
      plotOutput("streams"),
      h4("Which Songs had the most streams?"),
      plotOutput("song_streams")
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
))
