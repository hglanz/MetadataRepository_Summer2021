#' This function scrapes metadata attributes from the Figshare metadata repository.
#' @import rvest
#' @import stringr
#' @import magrittr
#' @import dplyr
#' @param url the website url
#' @return dataframe with metadata attributes
#' @export

scrape_figshare <- function(url) {
  name <- scrape_rvest(url, "._3lGK4")
  if(is.na(checkNull(name))) {
    name <- checkNull(scrape_rvest(url, "h1 div"))
  }
  description <- scrape_rvest(url, "._1dO13")
  if(is.na(checkNull(description))) {
    description <- checkNull(scrape_rvest(url, "p"))
  }
  authors <- scrape_rvest(url, "._2NQ4c , ._23TUJ p")
  authors <- authors[2:length(authors)]
  cols <- scrape_rvest(url, "._36trp , ._14z3R , ._1qu0d+ span")
  categories <- scrape_rvest(url, "li")
  categories <- categories[!str_detect(categories, "https://")]
  keywords <- scrape_rvest(url, "._3v5nv span")
  if(is.na(checkNull(keywords))) {
    keywords <- checkNull(scrape_rvest(url, "._3A6L3"))
  }
  date <- scrape_rvest(url, "._1qu0d")
  date <- checkNull(date)
  exports <- scrape_rvest(url, "button span")
  exports <- exports[exports != "Select an option"]
  file_info_cols <- c("FileName", "Size")
  file_info_data <- checkNull(scrape_rvest(url, "._1KU5g span"))
  df <- data.frame(Name = checkNull(name), Description = checkNull(description), Authors = checkNull(paste(authors, collapse = ", ")), Categories = checkNull(paste(categories, collapse = ", ")), Keywords = checkNull(paste(keywords, collapse = ", ")), Date = checkNull(date), Exports = checkNull(paste(exports, collapse = ", ")))
  count <- 1
  for(i in file_info_cols) {
    df[i] <- checkNull(file_info_data[count])
    count <- count+1
  }
  return(df)
}
