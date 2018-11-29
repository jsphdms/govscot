count_mentions <- function(url = NULL,
                           pattern = "National Records of Scotland") {

  string_count <- pdftools::pdf_text(url) %>%
    str_count(pattern = pattern) %>%
    sum()

  return(string_count)

}

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
                                              "Research", "Statistics", "Transport", "Work and skills")) {

  publication_html <- xml2::read_html(url)

  documents <- publication_html %>%
    rvest::html_nodes(".no-icon") %>%
    html_attr(name = "href") %>%
    paste0("https://www.gov.scot", .) %>%
    if (length(.) == 0) NA_character_ else .

  metadata <- data.frame(type = publication_html %>%
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
                           ifelse(length(.) == 0, NA_character_, .))



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
