link <- Frost2021Package::links("https://figshare.com/browse", ".WA1B-")
full_df <- data.frame(matrix(ncol = 8, nrow = 0))
for(i in link) {
  if(!str_detect(i, "https://")) {
    i <- paste("https:", i, sep = "")
  }
  print(i)
  print(nrow(full_df))
  tryCatch(expr = {
    full_df <- rbind(full_df, scrape_figshare(i))
  }, error = function(err) {
    NULL
  })
  cat("\014")
}
