full_df <- read.csv("./Data/datashare_scraped.csv")
for(i in 3:172) {
  url <- paste("https://datashare.ed.ac.uk/discover?rpp=20&etal=0&group_by=none&page=", i, sep = "")
  link <- Frost2021Package::links(url, ".artifact-description :nth-child(1)")
  link <- link[!is.na(link)]
  link <- paste("https://datashare.ed.ac.uk", link, sep = "")
  for(j in link) {
    print(j)
    print(nrow(full_df))
    full_df <- rbind(full_df, scrape_datashare(j))
    cat("\014")
  }
}
