full_df <- data.frame(matrix(ncol = 13, nrow = 0))
for(i in 1:11944) {
  url <- paste("https://dataverse.harvard.edu/dataverse/harvard?q=&types=dataverses%3Adatasets&sort=dateSort&order=desc&page=", i, sep = "")
  links <- Frost2021Package::links(url, ".card-title-icon-block a")
  links <- paste("https://dataverse.harvard.edu", links, sep = "")
  links <- links[str_detect(links, "/dataset")]
  for(j in links) {
    print(j)
    print(nrow(full_df))
    tryCatch(expr = {full_df <- rbind(full_df, scrape_harvard(j))}, error = function(error) {
      NULL
    })
    cat("\014")
  }
}
full_df <- rbind(target(read.csv("./Data/harvard_actual_scraped.csv"), names(full_df)), full_df)
