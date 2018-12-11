
scrape_publications <- function(urls = NULL) {

  topic_text <- xml2::read_html("https://www.gov.scot/topics/") %>%
    rvest::html_nodes(".az-list__link") %>%
    rvest::html_text()


  scrape_publication <- ratelimitr::limit_rate(scrape_publication, ratelimitr::rate(n = 1, period = 1))

  metadata <- lapply(urls, scrape_publication, topic_list = topic_text) %>%
    dplyr::bind_rows()

  return(metadata)

}
