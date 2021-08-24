l <- links("https://datahub.io/search", "a")
l <- l[str_detect(l, "/core/")]
l <- paste("https://datahub.io", l, sep = "")
l <- data.frame(l) %>% distinct() %>% c()
l <- l$l
full_df <- data.frame(matrix(ncol = 11, nrow = 0))
for(i in l) {
  print(nrow(full_df))
  print(i)
  full_df <- rbind(full_df, scrape_datahub(i))
  cat("\014")
}
