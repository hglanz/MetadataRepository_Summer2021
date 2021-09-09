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
full_df <- data.frame(matrix(ncol = 13, nrow = 0))
pages <- scrape_rvest("https://data.ca.gov/dataset?q=&sort=score+desc%2C+metadata_modified+desc", ".disabled+ li a") %>% parse_number()
seq <- 1:pages
for(i in seq) {
  count <- 1
  url <- paste("https://data.ca.gov/dataset?q=&sort=score+desc%2C+metadata_modified+desc&page=", i, sep = "")
  pg <- read_html(url)
  link <- paste("https://data.ca.gov", html_attr(html_nodes(read_html(url), ".dataset-heading a"), "href"), sep = "") %>% data.frame() %>% distinct()
  link <- link[str_detect(link, "/dataset")]
  for(j in link$.) {
    data_link <- j
    print(nrow(full_df))
    print(j)
    tryCatch(expr = {
      data <- scrape_cdph(data_link)
      data$`Link` <- j
      file_type_css <- paste(".dataset-item:nth-child(", count, ").label", sep = "")
      file_type <- scrape_rvest(url, file_type_css) %>% paste(collapse = ", ") %>% checkNull()
      data$FileType <- file_type
      full_df <- rbind(full_df, data)
    }, error = function(err) {
      NULL
    })
    count <- count+1
    system("clear")
  }
}
original <- read.csv("./Data/cdph_scraped.csv")
full_df <- target(full_df, names(original))
full_df <- rbind(full_df, original)
full_df <- distinct(full_df, Name, .keep_all = TRUE)
write.csv(full_df, "./Data/cdph_scraped.csv")
