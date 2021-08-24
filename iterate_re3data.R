full_df <- data.frame(matrix(ncol = 10, nrow = 0))
for(i in 1:109) {
  link <- links(paste("https://www.re3data.org/search?query=&page=", i, sep = ""), "a")
  link <- link %>% data.frame() %>% distinct()
  link <- link$.
  link <- link[str_detect(link, "/repository") & !is.na(link)]
  link <- paste("https://re3data.org", link, sep = "")
  for(j in link) {
    print(j)
    print(nrow(full_df))
    tryCatch(expr = {
      full_df <- rbind(full_df, scrape_re3data(j))
    }, error = function(error) {
      NULL
    })
    cat("\014")
  }
}
