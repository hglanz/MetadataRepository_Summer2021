#### [ CORGIs Repository Scraping ] ####
library(tidyverse)
library(rvest)

metadata_all <- data.frame(
  type = "",
  delimiter = "",
  extension = "",
  format = "",
  nrows = NA,
  ncols = NA,
  file_size = NA,
  nnum_vars = NA,
  nchar_vars = NA,
  num_vars = "",
  char_vars = "",
  tasks = "",
  num_files = NA,
  title = "",
  link = "",
  author = "",
  publisher = "",
  citation_request = "",
  description = "",
  date_submitted = "",
  date_created = "",
  tags = ""
)


#### Single Dataset Table Sample Scrape (Function) ####
url <- "https://corgis-edu.github.io/corgis/csv/aids/"

corgis_single_scrape <- function(url) {
  dsname <- strsplit(url, split = "/")[[1]]
  dsname <- str_replace_all(dsname[length(dsname)], "_", "-")
  webpage <- read_html(url)
  metadata_html <- html_nodes(webpage, css = paste0("td , th , p , #", dsname, "-csv-file"))
  metadata <- html_text(metadata_html)
  
  metadata_all <- data.frame(
    type = "",
    delimiter = "",
    extension = "",
    format = "",
    nrows = NA,
    ncols = NA,
    file_size = NA,
    nnum_vars = 0,
    nchar_vars = 0,
    num_vars = "",
    char_vars = "",
    tasks = "",
    num_files = NA,
    title = "",
    link = "",
    author = "",
    publisher = "",
    citation_request = "",
    description = "",
    date_submitted = "",
    date_created = "",
    tags = ""
  )
  
  metadata_all$delimiter <- ","
  metadata_all$extension <- "csv"
  metadata_all$title[1] <- metadata[2]
  metadata_all$description[1] <- metadata[5]
  metadata_all$tags[1] <- str_replace(str_extract(metadata[4], "Tags:.*"), "Tags: ", "")
  metadata_all$date_submitted[1] <- str_extract(metadata[4], "[0-9]*/[0-9]*/[0-9]{4}")
  metadata_all$publisher[1] <- metadata[3]
  metadata_all$author[1] <- str_replace(str_replace(str_extract(metadata[4], "By .*Version"), "Version", ""), "By ", "")
  
  for (i in 1:length(metadata)) {
    if (metadata[i] %in% c("Integer", "Float")) {
      metadata_all$nnum_vars[1] <- metadata_all$nnum_vars[1] + 1
      if (metadata_all$nnum_vars[1] == 1) metadata_all$num_vars[1] <- metadata[i-1]
      else metadata_all$num_vars[1] <- paste(metadata_all$num_vars[1], metadata[i-1], sep = ",")
      
    } else if (metadata[i] == "String") {
      metadata_all$nchar_vars[1] <- metadata_all$nchar_vars[1] + 1
      if (metadata_all$nchar_vars[1] == 1) metadata_all$char_vars[1] <- metadata[i-1]
      else metadata_all$char_vars[1] <- paste(metadata_all$char_vars[1], metadata[i-1], sep = ",")
    }
  }
  metadata_all$ncols[1] <- metadata_all$nnum_vars[1] + metadata_all$nchar_vars[1]
    
  return(metadata_all)
}

# d <- corgis_single_scrape(url)



#### Scrape All Dataset Pages ####
corgis_url <- "https://corgis-edu.github.io/corgis/csv/"
url <- "https://corgis-edu.github.io/corgis/csv/"
webpage <- read_html(url)
datalist_html <- str_replace_all(str_to_lower(html_text(html_nodes(webpage, css = "h3"))), " ", "_")
datalist <- paste0(corgis_url, datalist_html)


metadata_all <- corgis_single_scrape(datalist[1])
for (i in 2:length(datalist)) {
  print(paste("iteration", i))
  metadata_all <- metadata_all %>%
    bind_rows(corgis_single_scrape(datalist[i]))
}

write_csv(metadata_all, "./Data/CORGIS_metadata.csv")
