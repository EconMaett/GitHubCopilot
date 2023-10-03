# create a function to solve the Keyword game
# this game uses a 6 letter horizontal word at the
# intersection of 6 other vertical words, 
# where a missing letter from each of the vertical words
# accounts for one letter of the mystery 6 letter length horizontal word

# how to play
# Guess 6 letters across.
# Letters must spell words across and down.

library(jsonlite)
url <- "https://keyword-client-prod.red.aws.wapo.pub/levels/2023/08/09.json"
raw_json <- fromJSON(url)
raw_json$answer
# "stable"

raw_json$words
# [1] "stable" "table"  "bale"   "able"   "slab"   "last"   "best"   "east"


# guess_keyword() function
# The keyword is one of the following:
# recipe, repipe

# The played words are some of the following:
# [r]aid, stat[e], [c]ap, gamb[i]t, [p]arent, decr[e]e
# [r]aid, stat[e], [p]ap, gamb[i]t, [p]arent, decr[e]e
