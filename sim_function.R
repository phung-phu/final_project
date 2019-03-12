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
# write.csv("data/calculated_sim.csv")
# vals <- read.csv("data/calculated_sim.csv", stringsAsFactors = FALSE)
# avg <- mean(vals$Repetitiveness)
# colnames(vals) <- c("Position", "Repetitiveness")
# us_top <- read.csv("data/us_top200.csv", stringsAsFactors = FALSE)
# rep <- right_join(us_top, vals, by = "Position") %>% 
#   mutate(Song = paste0("<a href =\"", URL, "\">", Track.Name, "</a>")) %>% 
#   select(Song, Artist, Repetitiveness)
# write.csv(rep, "repetitiveness.csv")

# Avg repetitiveness
# avg_rep <- "1.99%"

# Test Code
# find_sim("Taylor Swift", "We Are Never Ever Getting Back Together")
