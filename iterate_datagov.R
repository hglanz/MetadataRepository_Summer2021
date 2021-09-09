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
library(devtools)
library(xts)
full_df <- data.frame(matrix(ncol = 10, nrow = 0))
args <- commandArgs(trailingOnly = TRUE)
if(length(args) != 0) {
  n <- args[1]
}
for(i in 1:15391) {
  url <- paste("https://catalog.data.gov/dataset?page=", i, sep = "")
  pg <- read_html(url)
  links <- html_attr(html_nodes(pg, ".dataset-heading a"), "href")
  links <- paste("https://catalog.data.gov", links, sep = "")
  links <- links %>% data.frame() %>% distinct()
  links <- links$.
  tryCatch(expr = {
    if(nrow(full_df) == n) {
      break
    }
  }, error = function(err) {
    NULL
  })
  for(j in links) {
    print(nrow(full_df))
    print(j)
    scraped <- scrape_datagov(j)
    system("clear")
    scraped <- target(scraped, c("Name", "Description", "Metadata.Created.Date", "Metadata.Updated.Date", "Publisher", "Tags", "Category", "Maintainer"))
    full_df <- rbind(full_df, scraped)
    tryCatch(expr = {
      if(nrow(full_df) == n) {
        break
      }
    }, error = function(err) {
      NULL
    })
  }
}
#original <- read.csv("./Data/datagov_scraped.csv")
#full_df <- target(full_df, names(original))
#full_df <- rbind(full_df, original)
#full_df <- distinct(full_df, Name, .keep_all = TRUE)
#write.csv(full_df, "./Data/datagov_scraped.csv")
full_df
