# create a json_url function that accepts a data argument
# the date argument should be in the format of "YYYY-MM-DD" but
# will need to use stringr to replace the "-" with "/" to match the url format
# using glue, create a url that matches
# "https://keyword-client-prod.red.aws.wapo.pub/levels/2023/08/09.json"
# but replace the 2023/08/09 with the cleaned date

json_url <- function(date) {
  # replace the "-" with "/"
  date <- stringr::str_replace_all(date, "-", "/")
  
  # create the url
  url <- glue::glue("https://keyword-client-prod.red.aws.wapo.pub/levels/{date}.json")
  
  # return the url
  url
}

json_url("2023-08-09")
# "https://keyword-client-prod.red.aws.wapo.pub/levels/2023/08/09.json"


raw_json <- json_url(date = "2023-08-09") %>% 
  jsonlite::fromJSON(simplifyVector = TRUE)

hints <- as.character(raw_json$words)
hints

