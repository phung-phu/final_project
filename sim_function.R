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

# Test Code
find_sim("Taylor Swift", "Enchanted")
