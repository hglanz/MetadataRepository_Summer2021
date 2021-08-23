library(tidyverse)
library(rvest)
library(Frost2021Package)
library(XML)
library(purrr)
library(bestpredictor)
library(lubridate)
library(DT)
library(rdryad)
library(plotly)
library(cronR)
library(devtools)

date <- wday(now())
if(date == 1 | date == 2) {
  curate("cdph", 100, write = TRUE)
  curate("datagov", 100, write = TRUE)
}else if(date == 3 || date == 4) {
  curate("datahub", 10, write = TRUE)
  curate("datashare", 100, write = TRUE)
}else if(date == 5 || date == 6) {
  curate("dryad", 100, write = TRUE)
  curate("harvard", 100, write = TRUE)
}else{
  curate("re3data", 100, write = TRUE)
  curate("zenodo", 20, write = TRUE)
}
