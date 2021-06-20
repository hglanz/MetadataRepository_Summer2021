#### [ UCI ML Repository Scraping ] ####
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
# url <- "https://archive.ics.uci.edu/ml/datasets/3D+Road+Network+%28North+Jutland%2C+Denmark%29"

uci_single_scrape <- function(url) {
  webpage <- read_html(url)
  metadata_html <- html_nodes(webpage, css = "td table")
  metadata <- html_table(metadata_html)
  
  if (length(metadata) > 1) {
    x <- metadata[[1]]
    y <- strsplit(str_replace_all(x, "\n|\t", "\\_"), split = "\\_")
    
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
    metadata_all$title[1] <- y[[1]][1]
    metadata_all$description[1] <- str_replace(y[[1]][grepl("Abstract", y[[1]])], "Abstract: ", "")
    metadata_all$tasks[1] <- str_to_lower(metadata[[2]]$X2[3])
    metadata_all$nrows[1] <- metadata[[2]]$X4[1]
    metadata_all$ncols[1] <- metadata[[2]]$X4[2]
    metadata_all$tags[1] <- str_to_lower(metadata[[2]]$X6[1])
    metadata_all$date_submitted[1] <- metadata[[2]]$X6[2]
    
    return(metadata_all)
  } else {
    return(NULL)
  }
}

#### Scrape All Dataset Pages ####
uci_url <- "https://archive.ics.uci.edu/ml/datasets/"
url <- "https://archive.ics.uci.edu/ml/datasets.php?format=&task=&att=&area=&numAtt=&numIns=&type=&sort=nameUp&view=list"
webpage <- read_html(url)
datalist_html <- html_nodes(webpage, css = "a")
datalist <- paste0(uci_url, str_replace(html_attr(datalist_html, "href")[39:597], "datasets/", ""))


metadata_all <- uci_single_scrape(datalist[1])
for (i in 2:length(datalist)) {
  print(paste("iteration", i))
  metadata_all <- metadata_all %>%
    bind_rows(uci_single_scrape(datalist[i]))
}

write_csv(metadata_all, "./Data/UCI_metadata.csv")
