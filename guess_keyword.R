# guess_keyword.R 
# https://gist.github.com/jthomasmock/197d385dfefbeef61ec5ef6cce0d0ecc
library(tidyverse)
library(jsonlite)
library(shiny)

# get_json_data(date)
# score_letters(letters)
# read_keywords() on mac
# split_char(word) into words
# limit_words(words, str_length) to specific length and lower case
# top_words(word, words_in, top_n = 50) - combo of split_char, limit_words
# letters_from_blank(word_in, top_words) - generates possible_letters
# possible_letters <- purrr::map(word_miss, ~letters_from_blank(.x, top_words(.x, words_in)))
# possible_words(generated_words, words_in)) -
### possible_keywords <- possible_words(generated_words, words_in)

guess_keyword <- function(date = Sys.Date(), return=FALSE) {
  
  # browser()
  
  # split words into letters
  
  split_char <- function(word) {
    stringr::str_split(word, "") |> unlist()
  }
  
  # score letters internal fn - thanks CoolButUseless!
  
  score_letters <- function(letters) {
    letter_freqs <- strsplit("etaoinshrdlcumwfgypbvkjxqz", "")[[1]]
    letter_scores <- setNames(1:26, letter_freqs)
    sum(letter_scores[tolower(letters)])
  }
  
  # get local keywords - thanks CoolButUseless!
  
  read_keywords <- function() {
    words_in <- readLines("/usr/share/dict/words")
    # words_in <- words_vec
    words_in[stringr::str_length(words_in) <= 6] |> tolower()
  }
  
  # limit the words to matching length and to lower case
  limit_words <- function(words, str_length) {
    words_in[stringr::str_length(words) == str_length] |> tolower()
  }
  
  # create a regex from a word w/ missing letters
  regex_from_word <- function(word) {
    word |>
      stringr::str_replace_all("_", "[a-z]") |>
      stringr::regex()
  }
  
  # given a list of multiple vectors of letters,
  # return a list of all possible combinations of letters
  
  cross_words <- function(possible_letters) {
    suppressWarnings(
      purrr::cross(possible_letters) |>
        purrr::map_chr(paste0, collapse = "")
    )
  }
  
  # limit the words to the top 50 best based on scoring
  
  top_words <- function(word, words_in, top_n = 50) {
    matched_words <- str_subset(limit_words(words_in, str_length(word)), regex_from_word(word))
    
    matched_words |>
      lapply(split_char) |>
      sapply(score_letters) |>
      setNames(matched_words, nm = _) |>
      sort() |>
      unique() |>
      head(top_n)
  }
  
  # letters from blank extracted
  
  letters_from_blank <- function(word_in, top_words) {
    # position of _ in the string
    pos <- stringr::str_locate(word_in, "_")[[1]]
    
    stringr::str_sub(top_words, pos, pos)
  }
  
  # given a vector of words in generated_words, vector subset it
  # with words_in that are 6 characters long and match or are in the generated words
  
  possible_words <- function(generated_words, words_in) {
    limited_words <- generated_words[generated_words %in% limit_words(words_in, 6)]
    
    limited_words |>
      lapply(split_char) |>
      sapply(score_letters) |>
      setNames(limited_words, nm = _) |>
      sort() |>
      unique() |>
      head(20)
  }
  
  # read the keywords in from local
  words_in <- read_keywords()
  
  
  # get json data from their web interface at Washington Post
  get_json_data <- function(date = date) {
    date_clean <- stringr::str_replace_all(date, "-", "/")
    
    url <- glue::glue("https://keyword-client-prod.red.aws.wapo.pub/levels/{date_clean}.json")
    # url <- gl
    
    json_in <- url |> fromJSON(simplifyVector = FALSE)
    
    return(json_in)
  }
  
  # browser()
  
  # get the missing words from json
  
  raw_json <- get_json_data(date = date)
  
  word_miss <- raw_json |>
    pluck("words") |>
    as.character()
  
  # return the possible letters
  
  possible_letters <- purrr::map(word_miss, ~ letters_from_blank(.x, top_words(.x, words_in)))
  
  # given a list of multiple vectors of letters,
  # return a list of all possible combinations of letters
  generated_words <- cross_words(possible_letters)
  
  # given a vector of words in generated_words, vector subset it with words_in that are 6 characters long and match or are in the generated words
  
  possible_keywords <- possible_words(generated_words, words_in)
  
  stopifnot("Word isn't in data banks!" = raw_json$answer %in% possible_keywords)
  
  # now using those keywords
  # replace the _ in the words with the letters from the keywords
  
  possible_ver_words <- possible_keywords |>
    lapply(split_char) |>
    # now paste those letters into the words with missing letters
    purrr::map(~ stringr::str_replace(word_miss, "_", glue::glue("[{.x}]")))
  
  cat(
    c(
      " The keyword is one of the following:\n",
      paste(possible_keywords, collapse = ", "),
      "\n\n",
      "The played words are some of the following:\n",
      # paste(possible_ver_words, collapse = ", "),
      paste0(
        purrr::map_chr(possible_ver_words, paste0, collapse = ", "),
        collapse = "\n "
      ),
      "\n\n"
    )
  )
  
  if(return) return(possible_ver_words)
}
# END