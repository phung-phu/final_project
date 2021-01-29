## INFO 201 Project Proposal
By Team Starfish: Phung Phu, Renee Wang, Xuhua Zou, Kyle Lawrence

## Project Description
## Analyzing Music
The web app is viewable at: https://reneew7.shinyapps.io/musicanalysis/

#### Our Datasets
We will be looking at a data set containing information on [Spotify's Worldwide Daily Song Ranking](https://www.kaggle.com/edumucelli/spotifys-worldwide-daily-song-ranking)
from 2016 to 2018. This data set was originally created by Eduardo, a software
engineer at BlaBlaCar.  In addition to that data set, we will also be using the
[Top Spotify Tracks of 2018](https://www.kaggle.com/nadintamer/top-spotify-tracks-of-2018)
dataset that gives us information about the audio features of the top Spotify songs in 2018.
This data set was created by Nadin Tamer, who gathered information about the descriptions
of the audio features from the Spotify API. By using both datasets, this will allow
us to provide the most popular song in a region and the audio features of the most
popular songs.


#### Intended Audience
Our primary target audience is music listeners who are curious about how popular music varies in different locations and what characteristics popular songs tend to have. In particular, we hope to find an audience in people who are passionate about listening to music and open to exploring new songs.


#### Specific Questions
Our data will provide answers to the following questions:
- What aspects of music makes it popular?
- What are some characteristics of popular music in general?
- What music is popular in different countries?


## Technical Description
Both of our datasets are static .csv files, which means we will be reading into data using static .csv files and won't be using APIs. One of the things we are hoping to do with these datasets is to see what aspects of songs land them on the popular charts, so we would need to join our datasets by songs for sure. One major challenge this might end up resulting in is that songs in one dataset might not be in another, which would limit our ability to analyze the songs across both datasets. However, since these datasets were established around the same time, we hope to at least be able to analyze songs on the US/English-dominated charts, if some foreign charts have a lot of songs not on the other dataset.

Besides `dplyr`, we will be using `shiny` app to present our final project. One of the visualizations we might want to do involves adjusting either the location or the day to see the top charts, which requires an interactive interface to do so. Adjusting the location will involve using libraries such as `Leaflet` and `ggplot2`. And we would draw statistical analysis for our data to display the relations.
