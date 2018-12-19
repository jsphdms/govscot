# govscot
An R package to responsibly scrape gov.scot

# Rationale
I am looking into how the impact of [NRS statistics](https://www.nrscotland.gov.uk/) on Scottish Government policy might be measured. One approach is to search through content on [gov.scot](www.gov.scot) for mentions of certain phrases relevant to NRS, to see if patterns arise over time or between different [directorates](https://www.gov.scot/about/how-government-is-run/directorates/) and [topics](https://www.gov.scot/topics/).

There are a number of ways this could be achieved. Here is a summary of my views on the pros and cons of each.

## Option 1 - Scrape google search results
### Pros
Google search results should all contain the strings you're searching for. So there should be less data to analyse.

### Cons
You're relying on Google search results which can change as Google's methodology changes.
This doesn't return all pages (i.e. the ones without mentions) which means you don't have a denominator to create rates from.

## Option 2 - Query an API
### Pros
This would return comprehensive and reasonably structured data which might avoid some of the messiness of scraping.

### Cons
As far as I know there is no API for content on gov.scot

## Option 3 - Request an export of data from the content management system
### Pros
This would be a comprehensive dataset to analyse.

### Cons
This would would only include web text (since I presume a zip file of all the supporting documents would be prohibitively large).

## Option 4 - Write a script (e.g. [Rvest](https://blog.rstudio.com/2014/11/24/rvest-easy-web-scraping-with-r/) or [Scrapy](https://scrapy.org/))
### Pros
This seems to be the only way to search through supporting documents (at least machine readable ones).

### Cons
Time needed to write a script.

## Option 5 - Use web crawling software (e.g. [Screaming Frog](https://www.screamingfrog.co.uk/seo-spider/))
### Pros
Less time to set up.

### Cons
These often cost money and may be time consuming to run on a regular basis.

## Option 6 - Use [Google custom search](https://developers.google.com/custom-search/)
### Pros
I'm not sure what the pros are.

### Cons
This could be technically challenging and there may be a cost involved. It might also be overkill.
