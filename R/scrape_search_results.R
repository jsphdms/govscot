
#' Scrape URLs for search results
#' @importFrom magrittr "%>%"
scrape_search_results <- function(url = NULL) {

  publication_html <- xml2::read_html(url)

  article <- publication_html %>%
    rvest::html_nodes(".search-results__item")

  search_results <- data.frame(url = article %>%
                                   rvest::html_node(".listed-content-item__link") %>%
                                   rvest::html_attr(name = "href") %>%
                                   paste0("https://www.gov.scot", .))

  return(search_results)

}
