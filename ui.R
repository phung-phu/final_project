# ui.R
library(shiny)
library(ggplot2)
library(dplyr)
library(lintr)
library(genius)
library(tidyverse)
library(songsim)
library(syuzhet)

shinyUI(navbarPage(
  "Analyzing Music",
  mainPanel(
    # home page  
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
        ),
        checkboxInput(
          "showMood",
          label = "Show Emotions Distribution"
        )
      ),
      mainPanel(
        plotOutput("sim_plot"),
        plotOutput("mood_graph")
      )
    )
  )#, - insert more tabs
))