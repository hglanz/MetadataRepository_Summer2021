#' This function calculates a similarity score between two strings.
#' @param a, string A
#' @param b, string B
#' @return similarity score
#' @export

similarity_score <- function(a, b) {
  score_a <- 0
  score_b <- 0
  a <- tolower(a)
  b <- tolower(b)
  for(i in 1:length(a)) {
    if(grepl(a[i], b)) {
      score_a <- score_a + (1/length(b))
    }
  }
  for(i in 1:length(b)) {
    if(grepl(b[i], a)) {
      score_b <- score_b + (1/length(a))
    }
  }
  return(c(score_a, score_b) %>% mean())
}
