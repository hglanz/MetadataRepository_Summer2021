full_df <- data.frame(matrix(ncol = 8, nrow = 0))
for(i in 1:15391) {
  url <- paste("https://catalog.data.gov/dataset?page=", i, sep = "")
  pg <- read_html(url)
  links <- html_attr(html_nodes(pg, ".dataset-heading a"), "href")
  links <- paste("https://catalog.data.gov", links, sep = "")
  links <- links %>% data.frame() %>% distinct()
  links <- links$.
  for(j in links) {
    scraped <- scrape_datagov(j)
    cat("\014")
    print(paste("Link:", j, "nrow =", nrow(full_df)))
    full_df <- rbind(full_df, scraped)
  }
}
original <- read.csv("./Data/datagov_scraped.csv")
full_df <- target(full_df, names(original))
full_df <- rbind(full_df, original)
full_df <- distinct(full_df, Name, .keep_all = TRUE)
write.csv(full_df, "./Data/datagov_scraped.csv")
