library(genius)
library(tidyverse)
library(dplyr)
library(songsim)

find_sim <- function(artist_name, song_name) {
  song_name <- gsub("\\s*\\[[^\\)]+\\]","", song_name)
  song_name <- gsub("\\s*\\([^\\)]+\\)","", song_name)
  song_lyrics <- genius_lyrics(artist = artist_name, song = song_name) %>% 
    select(lyric) %>% 
    filter(lyric != "NA")
  write.table(song_lyrics, "lyrics.txt",
              row.names = FALSE,
              quote = FALSE,
              col.names = FALSE)
  bestsongsim <- songsim("lyrics.txt", colorfulMode = TRUE, 
                         mainTitle = paste0(song_name, " - ", artist_name))
  bestsongsim
}

find_sim_val <- function(artist_name, song_name) {
  find_sim(artist_name, song_name)$repetitiveness * 100 
}

# Code for calculating repetition values for each song, keep commented out
# us_top <- read.csv("data/us_top200.csv", stringsAsFactors = FALSE)
# itrs <- nrow(us_top)
# ls <- vector("list", length = itrs)
# for (i in 1:itrs) {
#   curr <- us_top[i,]
#   curr_artist <- curr$Artist
#   curr_song <- curr$Track.Name
#   ls [[i]] <- find_sim_val(curr_artist, curr_song)
# }
# ls[1:200]
# v <- unlist(ls, use.names = FALSE)
# df <- data.frame(v)
#write.csv("data/calculated_sim.csv")

vals <- read.csv("data/calculated_sim.csv", stringsAsFactors = FALSE)

# Test Code
find_sim_val("Bruno Mars", "Thats What I Like")
