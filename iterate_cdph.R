full_df <- data.frame(matrix(ncol = 12, nrow = 0))
seq <- 1:119
for(i in seq) {
  i <- sample(seq, 1)[1]
  url <- paste("https://data.ca.gov/dataset?q=data&page=", i, sep = "")
  pg <- read_html(url)
  links <- paste("https://data.ca.gov", html_attr(html_nodes(read_html(url), ".dataset-heading a"), "href"), sep = "") %>% data.frame() %>% distinct()
  for(j in links$.) {
    data_link <- j
    tryCatch(expr = {
      full_df <- rbind(full_df, scrape_cdph(data_link))
    }, error = function(err) {
      NULL
    })
  }
}
original <- read.csv("./Data/cdph_scraped.csv")
full_df <- target(full_df, names(original))
full_df <- rbind(full_df, original)
full_df <- distinct(full_df, Name, .keep_all = TRUE)
write.csv(full_df, "./Data/cdph_scraped.csv")
