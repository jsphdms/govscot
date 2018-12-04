
#' Scrape metadata for research listings
#' @importFrom magrittr "%>%"
scrape_research_listing <- function(url = NULL) {

  publication_html <- xml2::read_html(url)

  article <- publication_html %>%
    rvest::html_nodes(".search-results__item")

  datetime_published <- article %>%
    rvest::html_node(".listed-content-item__date") %>%
    rvest::html_text(trim = TRUE) %>%
    lubridate::dmy_hm()

  title <- article %>%
    rvest::html_nodes(".listed-content-item__title") %>%
    rvest::html_text(trim = TRUE)

  summary <- article %>%
    rvest::html_node(".listed-content-item__summary") %>%
    rvest::html_text(trim = TRUE)

  url <- article %>%
    rvest::html_node(".listed-content-item__link") %>%
    rvest::html_attr(name = "href") %>%
    paste0("https://www.gov.scot", .)

  research_listing <- data.frame(
    datetime_published = datetime_published,
    title = title,
    summary = summary,
    url = url
  ) %>%
    dplyr::mutate(title = dplyr::na_if(title, "")) %>%
    dplyr::mutate(summary = dplyr::na_if(summary, ""))

  return(research_listing)

}
