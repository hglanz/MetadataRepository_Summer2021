full_df <- data.frame(matrix(ncol = 10, nrow = 0))
for(i in 1:41864) {
  url <- paste("https://datadryad.org/search?page=", i, "&q=", sep = "")
  pg <- read_html(url)
  links <- html_attr(html_nodes(pg, "#documents a"), "href")
  links <- paste("https://datadryad.org", links, sep = "")
  links <- data.frame(links) %>% distinct()
  links <- links$links
  for(j in links) {
    print(j)
    print(nrow(full_df))
    tryCatch(expr = {
      full_df <- rbind(full_df, scrape_dryad(j))
    }, error = function(err) {
      NULL
    })
    cat("\014")
  }
}
