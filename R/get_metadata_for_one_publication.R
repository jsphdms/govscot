#' Scrape metadata for one publication
#' @importFrom magrittr "%>%"

scrape_metadata_for_one_publication <- function(url = NULL) {

  metadata <- list()

  publication_html <- xml2::read_html(url)

  metadata[["topics"]] <- publication_html %>%
    rvest::html_nodes(xpath = "//dt[contains(text(),'Part of:')]/following-sibling::dd/a") %>%
    rvest::html_text(trim = TRUE) %>%
    if (length(.) == 0) NA_character_ else .

  metadata["type"] <- publication_html %>%
    rvest::html_node(".article-header__label") %>%
    rvest::html_text() %>%
    ifelse(length(.) == 0, NA_character_, .)

  metadata["directorate"] <- publication_html %>%
    rvest::html_nodes(xpath = "//dt[contains(text(),'Directorate:')]/following-sibling::dd[1]") %>%
    rvest::html_text(trim = TRUE) %>%
    ifelse(length(.) == 0, NA_character_, .)

  metadata["isbn"] <- publication_html %>%
    rvest::html_nodes(xpath = "//dt[contains(text(),'ISBN:')]/following-sibling::dd[1]") %>%
    rvest::html_text(trim = TRUE) %>%
    ifelse(length(.) == 0, NA_character_, .)

  metadata["date_of_meeting"] <- publication_html %>%
    rvest::html_nodes(xpath = "//span[contains(text(),'Date of meeting:')]/following-sibling::span[1]") %>%
    rvest::html_text(trim = TRUE) %>%
    ifelse(length(.) == 0, NA, .)

  metadata["location"] <- publication_html %>%
    rvest::html_nodes(xpath = "//span[contains(text(),'Location:')]/following-sibling::span[1]") %>%
    rvest::html_text(trim = TRUE) %>%
    ifelse(length(.) == 0, NA_character_, .)

  metadata["contact"] <- publication_html %>%
    rvest::html_nodes(".publication-info__contact a") %>%
    rvest::html_text(trim = TRUE) %>%
    ifelse(length(.) == 0, NA_character_, .)

  return(metadata)

}
