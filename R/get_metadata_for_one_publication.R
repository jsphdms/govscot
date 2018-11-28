#' Scrape metadata for one publication
#' @importFrom magrittr "%>%"

scrape_publication <- function(url = NULL, topic_list = NULL) {

  publication_html <- xml2::read_html(url)

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
