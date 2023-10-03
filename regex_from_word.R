# given a word like "_ack" return a regex that will match
# the known letters, but any lower case letter instead of _
regex_from_word <- function(word) {
  # split the word into a vector of characters
  word_chars <- strsplit(word, "")[[1]]
  # replace any _ with a lower case letter
  word_chars[word_chars == "_"] <- "[a-z]"
  # paste the characters back together
  regex <- paste(word_chars, collapse = "")
  # return the regex
  regex
}


# recreate the function regex_from_word using the stringr package
regex_from_word <- function(word) {
  # replace any _ with a lower case letter
  regex <- stringr::str_replace_all(word, "_", "[a-z]")
  # return the regex
  regex
}

# recreate the function regex_from word using the |> pipe operator
regex_from_word <- function(word) {
  # replace any _ with a lower case letter
  regex <- word |> stringr::str_replace_all("_", "[a-z]")
  # return the regex
  regex
}

# recreate the function from above but this time do not assign the regex
# but instead call stringr::regex()
regex_from_word <- function(word) {
  # replace any _ with a lower case letter
 word |> 
    stringr::str_replace_all("_", "[a-z]") |> 
    stringr::regex()
}

matched_words <- stringr::str_subset(string = limit_words(words_in, 4), regex_from_word("_ack"))


# put the matched words into a function that also allows split_char
# and score_letters to return the top 50 most likely words
top_words <- function(words, word, split_char = "", score_letters = 0) {
  # create a regex from the word
  regex <- regex_from_word(word)
  
  # subset the words
  matched_words <- stringr::str_subset(string = words, regex)
  
  # split the words
  if (split_char != "") {
    matched_words <- stringr::str_split(matched_words, split_char)
  }
  
  # score the words
  if (score_letters != 0) {
    matched_words <- score_words(matched_words, score_letters)
  }
  
  # return the top 50 words
  matched_words[1:50]
}

