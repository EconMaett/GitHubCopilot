# GitHub Copilot for RStudio ----

## What is Copilot?

# GitHub Copilot is an AI pair programmer that offers **autocomplete-style**
# suggestions and real-time hints for the code you are writing by providing
# **suggestions as "ghost text"** based on the context of the surrounding code
# - GitHub Copilot docs


## Auto complete ----

# - Parses code and environment

# - Supplies possible completions

# - Static set of completions in popup

# - IDE provided from local disk


## Copilot ----

# - Parses code, environment and training data

# - Supplies likely completions

# - Dynamic set of completions via 'ghost text'

# - Generative AI provided via API endpoint



## Auto complete vs Copilot ----

# Take the mean of the MPG column in mtcars dataset
mean(mtcars$MPG)


# calculate the average fuel efficiency of cars grouped by cyl
library(dplyr)
mtcars %>%
  group_by(cyl) %>%
  summarise(mean(mpg))

