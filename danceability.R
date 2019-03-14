library(dplyr)
library(ggplot2)
library(shiny)
library(leaflet)
library(plotly)


# create plot showing the effects of different variables on danceability

top_2018 <- read.csv("data/top2018.csv", stringsAsFactors = FALSE) 

server <- function(input, output) {
  
  output$dance_plot <- renderPlotly({
    danceability_plot <- ggplot(data = top_2018, 
                                mapping = aes_string(x = input$x_var, y = "danceability", 
                                                     color = "danceability")) +
      geom_point() +
      geom_smooth() 
    ggplotly(danceability_plot)
  })
}

select_values <- c("energy", "loudness", "speechiness", "acousticness", 
                   "valence", "liveness", "tempo")

ui <- fluidPage(
  
  h1("Factors of Danceability"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "x_var",
        label = "X Variable",
        choices = select_values
      )
    ),
    mainPanel(
      plotlyOutput("dance_plot"),
      p("This interactive plot shows different factors that affect the danceability of song. The data points used are the Top 100 songs of 2018.")
    )
  )
)

shinyApp(ui = ui, server = server)
