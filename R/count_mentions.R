count_mentions <- function(url = NULL,
                           pattern = "National Records of Scotland") {

  string_count <- pdftools::pdf_text(url) %>%
    stringr::str_count(pattern = pattern) %>%
    sum()

  Sys.sleep(1)

  return(string_count)

}
