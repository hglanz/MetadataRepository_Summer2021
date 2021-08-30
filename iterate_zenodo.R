library(tidyverse)
library(rvest)
library(Frost2021Package)
library(XML)
library(purrr)
library(bestpredictor)
library(lubridate)
library(DT)
library(rdryad)
library(plotly)
library(cronR)
full_df <- data.frame(matrix(ncol = 8, nrow = 0))
for(i in 1:1) {
  url <- paste("https://zenodo.org/search?page=", i, "&size=20#", sep = "")
  pg <- read_html(url)
  links <- html_attr(html_nodes(pg, "h4 a"), "href")
  links <- links[str_detect(links, "/record/")]
  links <- paste("https://zenodo.org", links, sep = "")
  for(j in links) {
    full_df <- rbind(full_df, Frost2021Package::scrape_zenodo(j))
    print(nrow(full_df))
  }
}
original <- read.csv("./Data/zenodo_scraped.csv")
full_df <- target(full_df, names(original))
full_df <- rbind(full_df, original)
full_df <- distinct(full_df, Name, .keep_all = TRUE)
write.csv(full_df, "./Data/zenodo_scraped.csv")
