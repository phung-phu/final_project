library(genius)
library(tidyverse)
library(dplyr)
library(songsim)
library(syuzhet)

get_sent <- function(artist_name, song_name) {
  song_name <- gsub("\\s*\\[[^\\)]+\\]","", song_name)
  song_name <- gsub("\\s*\\([^\\)]+\\)","", song_name)
  song_lyrics <- genius_lyrics(artist = artist_name, song = song_name) %>% 
    select(lyric) %>% 
    filter(lyric != "NA")
  words <- song_lyrics$lyric
  nrc <- get_nrc_sentiment(words)
  nrc
}

get_graph <- function(nrc) {
  barplot(
    sort(colSums(prop.table(nrc[, 1:8]))), 
    col = rainbow(10, s = 0.7),
    horiz = TRUE, 
    cex.names = 0.7, 
    las = 1, 
    main = "Song Emotions", xlab="Percentage"
  )
}

# Test Code
n <- get_sent("Ed Sheeran", "Give Me Love")
get_graph(n)
