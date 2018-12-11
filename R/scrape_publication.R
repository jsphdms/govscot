#' Scrape metadata for one publication
#' @importFrom magrittr "%>%"

scrape_publication <- function(url = NULL,
                               topic_list = c("Arts, culture and sport", "Brexit", "Building, planning and design",
                                              "Business, industry and innovation", "Children and families",
                                              "Communities and third sector", "Constitution and democracy",
                                              "Economy", "Education", "Energy", "Environment and climate change",
                                              "Equality and rights", "Farming and rural", "Health and social care",
                                              "Housing", "International", "Law and order", "Marine and fisheries",
                                              "Money and tax", "Public safety and emergencies", "Public sector",
                                              "Research", "Statistics", "Transport", "Work and skills"),
                               pattern = "National Records of Scotland") {

  force(topic_list)

  publication_html <- xml2::read_html(url)

  supporting_document_urls <- publication_html %>%
    rvest::html_nodes(".no-icon") %>%
    rvest::html_attr(name = "href")

  metadata <- data.frame(date_published = publication_html %>%
                           rvest::html_node(xpath = "//span[contains(text(),'Published:')]/following-sibling::span[1]") %>%
                           rvest::html_text(trim = TRUE) %>%
                           ifelse(length(.) == 0, NA, .) %>%
                           lubridate::dmy(),
                         title = publication_html %>%
                           rvest::html_node(".article-header__title") %>%
                           rvest::html_text(trim = TRUE),
                         summary = publication_html %>%
                           rvest::html_node(".leader") %>%
                           rvest::html_text(trim = TRUE),
                         type = publication_html %>%
                           rvest::html_node(".article-header__label") %>%
                           rvest::html_text() %>%
                           ifelse(length(.) == 0, NA_character_, .),
                         directorate = publication_html %>%
                           rvest::html_nodes(xpath = "//dt[contains(text(),'Directorate:')]/following-sibling::dd[1]") %>%
                           rvest::html_text(trim = TRUE) %>%
                           ifelse(length(.) == 0, NA_character_, .),
                         isbn = publication_html %>%
                           rvest::html_nodes(xpath = "//dt[contains(text(),'ISBN:')]/following-sibling::dd[1]") %>%
                           rvest::html_text(trim = TRUE) %>%
                           ifelse(length(.) == 0, NA_character_, .),
                         date_of_meeting = publication_html %>%
                           rvest::html_nodes(xpath = "//span[contains(text(),'Date of meeting:')]/following-sibling::span[1]") %>%
                           rvest::html_text(trim = TRUE) %>%
                           ifelse(length(.) == 0, NA, .),
                         contact = publication_html %>%
                           rvest::html_nodes(".publication-info__contact a") %>%
                           rvest::html_text(trim = TRUE) %>%
                           ifelse(length(.) == 0, NA_character_, .),
                         mentions_web_page = publication_html %>%
                           rvest::html_text(trim = TRUE) %>%
                           stringr::str_count(pattern = pattern) %>%
                           ifelse(length(.) == 0, NA_character_, .),
                         number_of_supporting_documents = length(supporting_document_urls),
                         stringsAsFactors = FALSE)

  if (length(supporting_document_urls) == 0) {

    metadata[["number_of_supporting_documents_with_mentions"]] <- 0
    metadata[["mentions_supporting_documents"]] <- 0

  } else {

    metadata[["number_of_supporting_documents_with_mentions"]] <-
      supporting_document_urls[supporting_document_urls != 0] %>%
      length()

    metadata[["mentions_supporting_documents"]] <- supporting_document_urls %>%
      paste0("https://www.gov.scot", .) %>%
      sapply(count_mentions, pattern = pattern) %>%
      sum()
  }

  topics <- publication_html %>%
    rvest::html_nodes(xpath = "//dt[contains(text(),'Part of:')]/following-sibling::dd/a") %>%
    rvest::html_text(trim = TRUE) %>%
    if (length(.) == 0) NA_character_ else .

  topics <- topic_list %in% topics %>%
    as.list() %>%
    as.data.frame(col.names = topic_list)

  metadata <- cbind(metadata, topics)

  return(metadata)

}

scrape_publication <- ratelimitr::limit_rate(scrape_publication, ratelimitr::rate(n = 1, period = 1))
