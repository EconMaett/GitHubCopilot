# copilot_keyword.R

# https://gist.github.com/jthomasmock/a77072d61de92314149f63780e22ab21

library(tidyverse)
library(jsonlite)

# create a function to solve the Keyword game
# this game uses a 6 letter horizontal word at the
# intersection of 6 other words, where a missing letter from each of the vertical words
# accounts for one letter of the mystery 6 letter length horizontal word

# how to play
# Guess 6 letters across.
# Letters must spell words across and down.

# Example:
words <- c("ou{x1}",
           "{x2}ack",
           "{x3}over",
           "gr{x4}d",
           "gol{x5}",
           "{x6}on")


letter_freqs  <- strsplit('etaoinshrdlcumwfgypbvkjxqz', '')[[1]]
letter_scores <- setNames(1:26, letter_freqs)
score_letters <- function(letters) sum(letter_scores[tolower(letters)])

# combine letters freqs, letters scores into the score_letters function
score_letters <- function(letters) {
  letter_freqs  <- strsplit('etaoinshrdlcumwfgypbvkjxqz', '')[[1]]
  letter_scores <- setNames(1:26, letter_freqs)
  sum(letter_scores[tolower(letters)])
}

score_letters(c('h', 'e', 'l', 'l', 'o'))
# 35

str_sub("tacos", 2, 2)
# "a"

glue::glue(words[1])
# Error in eval(parse(text = text, keep.source = FALSE), envir) : 
#   Object 'x1' not found


read_keywords <- function(){
  words_in <- readLines("/usr/share/dict/words")
  words_in[stringr::str_length(words_in) <= 6] |> tolower()
}

words_in <- read_keywords()

local_keywords <- read_keywords()

local_keywords |>
  sapply(score_letters)

# create a json_url function that accepts a date argument
# the date argument should be in the format of "YYYY-MM-DD" but
# will need to use stringr to replace the "-" with "/" to match the url format
# using glue, create a url that matches
# "https://keyword-client-prod.red.aws.wapo.pub/levels/2023/08/09.json"
# but replace the 2023/08/09 with the cleaned date

json_url <- function(date = Sys.Date()){
  date_clean <- stringr::str_replace_all(date, "-", "/")
  
  url <- glue::glue("https://keyword-client-prod.red.aws.wapo.pub/levels/{date_clean}.json")
  
  return(url)
}


json_in <- json_url(Sys.Date()) |> fromJSON(simplifyVector = FALSE)

# combine the json_url and json_in into a function to return the json from the url

get_json_data <- function(date = Sys.Date()){
  date_clean <- stringr::str_replace_all(date, "-", "/")
  
  url <- glue::glue("https://keyword-client-prod.red.aws.wapo.pub/levels/{date_clean}.json")
  
  json_in <- url |> fromJSON(simplifyVector = FALSE)
  
  return(json_in)
}

get_json_data()

word_miss <- json_in$words |> as.character()
# in a vector of 6 words, replace the letter '_' with the '{x1}' where the number is the index of the word in the vector

word_miss |> stringr::str_replace_all("_", "{x1}")

purrr::map2_chr(word_miss, 1:6, ~stringr::str_replace_all(.x, "_", glue::glue("{{x{.y}}}")))

# split a string into a vector of characters

split_char <- function(word){
  stringr::str_split(word, "") |> unlist()
}

split_char("date") |>
  score_letters()

# create a function that takes a vector of words and a string length
# and returns the words that match the length of the mystery word

limit_words <- function(words, str_length){
  words_in[stringr::str_length(words)==str_length]
}

# given a word like "_ack" return a regex that will match the known letters, but any lower case letter instead of _

regex_from_word <- function(word){
  word |>
    stringr::str_replace_all("_", "[a-z]") |>
    stringr::regex()
}

regex_from_word("_ack")

matched_words <- str_subset(limit_words(words_in, 4), regex_from_word("_ack"))

matched_words |>
  lapply(split_char) |>
  sapply(score_letters) |>
  setNames(matched_words, nm = _)|>
  sort() |>
  head(10)

"_ack" |>
  stringr::str_replace_all("_", "[a-z]")


word_miss[2] |> regex_from_word()

limit_words(words_in, 4) |>
  lapply(split_char) |>
  sapply(score_letters) |>
  setNames(limit_words(words_in, 4), nm = _)|>
  sort() |>
  head(10)

# put the matched_words into a function that also allows split_char and score_letters to return the top 50 most likely words

top_words <- function(word, words_in, top_n = 50){
  matched_words <- str_subset(limit_words(words_in, str_length(word)), regex_from_word(word))
  
  matched_words |>
    lapply(split_char) |>
    sapply(score_letters) |>
    setNames(matched_words, nm = _)|>
    sort() |>
    unique() |>
    head(top_n)
}

top_words("_over", words_in)

letters_from_blank <- function(word_in, top_words){
  # position of _ in the string
  pos <- stringr::str_locate(word_in, "_")[[1]]
  
  stringr::str_sub(top_words, pos, pos)
  
}

letters_from_blank("gol_", top_words("gol_", words_in))

possible_letters <- purrr::map(word_miss, ~letters_from_blank(.x, top_words(.x, words_in)))

possible_letters

# given a list of multiple vectors of letters, return a list of all possible combinations of letters

cross_words <- function(possible_letters){
  purrr::cross(possible_letters) |>
    purrr::map_chr(paste0, collapse = "")
}

generated_words <- cross_words(possible_letters)

possible_letters |>
  expand_grid()
# given a vector of words in generated_words, vector subset it with words_in that are 6 characters long and match or are in the generated words

possible_words <- function(generated_words, words_in){
  limited_words <- generated_words[generated_words %in% limit_words(words_in, 6)]
  
  limited_words |>
    lapply(split_char) |>
    sapply(score_letters) |>
    setNames(limited_words, nm = _)|>
    sort() |>
    unique() |>
    head(20)
}

possible_keywords <- possible_words(generated_words, words_in)

# now using those keywords, replace the missing _ in the words with the split letters from keywords

# split the keywords into a vector of characters

split_char(possible_keywords[1])

# replace the _ in the words with the letters from the keywords

possible_ver_words <- possible_keywords |>
  lapply(split_char) |>
  # now paste those letters into the words with missing letters
  purrr::map(~stringr::str_replace(word_miss, "_", .x))

word_miss |>
  str_replace("_", possible_keywords[2] |>
                sapply(split_char))

word_miss |>
  lapply()


json_url("2023-08-14")

# simplify a list of lists into a single character string but separated by a new line

json_in$words |>
  purrr::map_chr(paste0, collapse = "\n")

# END