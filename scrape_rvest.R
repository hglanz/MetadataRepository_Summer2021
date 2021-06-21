#' @author Sucheen Sundaram
#' @import rvest
#' @import stringr
#' @import dplyr
#' @import magrittr
#' @param url the website url
#' @param type the html formatting type to extract the correct items
#' @export scrape_rvest

scrape_rvest <- function(url, type) {
  html_fm <- rvest::read_html(url)
  descriptions <- html_fm %>% rvest::html_nodes(type) %>% html_text() %>%
    str_remove_all("\n") %>%
    str_trim()
  return(descriptions)
}
