scrape_publications <- function(urls = NULL) {

  topic_text <- xml2::read_html("https://www.gov.scot/topics/") %>%
    rvest::html_nodes(".az-list__link") %>%
    rvest::html_text()

  metadata <- lapply(urls, scrape_publication, topic_list = topic_text) %>%
    dplyr::bind_rows()

  return(metadata)

}
