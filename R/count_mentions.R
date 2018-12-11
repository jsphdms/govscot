count_mentions <- function(url = NULL,
                           pattern = "National Records of Scotland") {

  string_count <- pdftools::pdf_text(url) %>%
    stringr::str_count(pattern = pattern) %>%
    sum()

  return(string_count)

}

count_mentions <- ratelimitr::limit_rate(count_mentions, ratelimitr::rate(n = 1, period = 1))
