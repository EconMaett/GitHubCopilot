# chattr.R ----

remotes::install_github("mlverse/chattr", force = TRUE)
library(chattr)

# Add your key to the "OPENAI_API_KEY" environment variable
# or add "open-ai-api-key" to a `config` YAML file

# Optain your OpenAI secret key to authanticate yourself as a user
# through this link: https://platform.openai.com/account/api-keys

# By default, `chattr` will look for the secret key inside an
# Environment Variable called `OPENAI_API_KEY`.

# You can use `Sys.setenv()` to set the key in the current session.
# The downside of using this method is that the variable will only be available
# during the current R session and that the key will be visible.
# `Sys.setenv("OPENAI_API_KEY" = "####################")`

# Instead, call
usethis::edit_r_environ()
# to save the key in a `.Renviron` file in your home directory.
# This way, there is no need to load the environment variable every time you
# start a new R session.

# The `.Renviron` file is always available in your home directory.
# You add an entry to the file by adding a line in the following format:
# `OPENAI_API_KEY=####################

## Using The App ----
chattr::chattr_app()
# Opens a Shiny app in the Viewer pane.
# Ask it "Can you show me an example of a plot?"
library(ggplot2)

# Create a data frame
data <- data.frame(x = c(1, 2, 3, 4, 5),
                   y = c(2, 4, 6, 8, 10))

# Create a scatter plot
ggplot(data, aes(x = x, y = y)) +
  geom_point()
graphics.off()


# After the LLM finishes its response, the `chattr` app processes
# all markdown code chunks.

# It will place three convenience buttons:

# - **Copy to clipboard** - copies the code chunk to the clipboard

# - **Copy to document** - copies the code chunk to the document
#   If the app is started while working on a script, 
#   `chattr` will copy the code to that same script.

# - **Copy to new script** - copies the code chunk to a new script.
#   Very useful when the LLM writes a Shiny app for you.


# The app will change its color scheme based on the current RStudio theme being light or dark.

# The settings screen can be accessed by clicking on the "gear" button.
# The screen that opens will contain the following:

# - Save and Open chats - allows you to save and retrieve past chats. `chattr` saves the file
#   in an RDS format.

# - Prompt settings - allows you to change the prompt settings for the LLM.
#   Including the number of max data files, and data frames sent to the LLM.


## How it works ----

# `chattr` enriches your request with additional instructions, name and structure of data
# frames currently in your environment, the path for the data files in your working directory.
# If supported by the model, `chattr` will include the current chat history.

# To see what `chattr` will send to the model, set the `preview` argument to `TRUE`:
library(chattr)

data("mtcars")
data("iris")

chattr(preview = TRUE)
# * Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference
# * Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference
# * Use tidyverse packages: readr, ggplot2, dplyr, tidyr
# * For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom
# * Avoid explanations unless requested by user, expecting code only
# * For any line that is not code, prefix with a: #
#   * Keep each line of explanations to no more than 80 characters
# * DO NOT use Markdown for the code


## Keyboard Shortcut ----

# Got to Tools -> Addins -> Browse Addins -> Keyboard Shortcuts
# Search for "Open Chat" and then change it to your preferred shortcut.


## Using the `chattr()` function ----

# The `chattr()` function is the main function of the package. 
# It takes a string as input.
# Here is an example of a request made to OpenAI:
library(chattr)
chattr("show me a simple recipe")


# Sure! Here's an example of a simple recipe using the `recipes` package from tidymodels:

library(recipes)

# Create a recipe
recipe_obj <- recipe(mpg ~ ., data = mtcars) %>%
  step_center(all_predictors()) %>%
  step_scale(all_predictors())

# Print the recipe
print(recipe_obj)


# This code creates a recipe object using the `recipe()` function from the `recipes` package. The formula `mpg ~ .` specifies that we want to predict the `mpg` variable using all other variables in the `mtcars` dataset. 

# The `step_center()` function is used to center all predictor variables, and the `step_scale()` function is used to scale them. These steps are common preprocessing steps to standardize the predictor variables.

# Finally, the `print()` function is used to display the recipe object.


## Highlight the request in a script ----

# In a script, `chattr` will process the current line, or the highlighted line(s)
# as the prompt.

# Because we assume that the request is not going to be code, then `chattr` will comment
# out the line or lines that were highlighted.

# Here is an example of a request made to OpenAI:
chattr("
       Create a function that:
  - Removes specified variables
  - Behaves like dplyr's select function
       ")


# Sure! Here's a function that removes specified variables from a data frame, behaving like dplyr's `select()` function:
  

library(dplyr)

remove_vars <- function(data, ...) {
    select(data, -one_of(...))
  }


# This function takes two arguments: `data`, which is the data frame from which variables will be removed, and `...`, which represents the variables to be removed.

# The `select()` function from the `dplyr` package is used to select variables from the data frame. By using the `-one_of(...)` syntax, we can remove the specified variables from the data frame.

# You can use this function as follows:
  

# Example usage
data <- data.frame(x = 1:5, y = 6:10, z = 11:15)

# Remove variables 'y' and 'z'
new_data <- remove_vars(data, "y", "z")


# In this example, the `remove_vars()` function is used to remove the variables "y" and "z" from the `data` data frame, resulting in a new data frame `new_data` with only the "x" variable.


chattr_defaults()

# The `type` argument can either be "notebook" or "chat".
chattr_defaults(type = "chat")

chattr("Show me a simple plot")

# Save the current defaults in a YAML file that is compatible with the
# "config" package
chattr_defaults_save(path = "chattr_config.yaml", overwrite = FALSE)


# Set the LLM model to use in your session
chattr_use()
# Available models are
# 1: Open AI - Completions - text-davinci-003 (davinci)
# 2: Open AI - Chat Completions - gpt-3.5-turbo (gpt35)
# 3: LlamaGPT - ~/ggml-gpt4all-j-v1.3-groovy.bin (llamagpt)

# Confirm connectivity to LLM interface
chattr_test()

# ch_test()


## Support for `glue` ----

# The `prompt` argument in `chattr` supports `glue` syntax.

# This means that you can pass current values of variables, or current output
# from functions within your current R session.

# Make sure that such output, or value, is a character that is readable
# by the LLM.

# Here is a simple example of a function that passes the variables 
# currently in your R session that contain "x":
my_list <- function() {
  return(ls(pattern = "x", envir = globalenv()))
}

# The `my_list()` function is passed to the `prompt` argument enclosed
# in curly braces:
chattr_defaults(prompt = "{ my_list() }")

# Now we can test it, by setting two variables that start with "x":
x1 <- 1
x2 <- 2

# To see what will be sent to the LLM, you can use `chattr(preview = TRUE)`.
# The two variables will be listed as part of the prompt:
chattr(preview = TRUE)

# We can see how the adding of a new variable will modify the prompt without
# us having to modify `chattr_defaults()`:

x3 <- 3

chattr(preview = TRUE)
