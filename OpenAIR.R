# OpenAIR ----

# Integrate OpenAI's GPT models in your R workflows

## Installation ----
devtools::install_github("umatter/OpenAIR")

## Usage ----
library("TheOpenAIR")

# register your api key with
# `openai_api_key("YOUR-API-KEY)`

usethis::edit_r_environ()

# Then you can use the `chat()` function to interact with ChatGPT.

# Ideally, you sue chat() in the R console

chat("Write a 100 words essay on why TheOpenAIR, an R package to integrate GPT models into your R workflows is fantastic. Write it in the style of product launches moderated by Steve Jobs.")
# Ladies and gentlemen, I am thrilled to introduce to you TheOpenAIR, an
# extraordinary R package that will revolutionize your data science
# workflows like never before. Just as Steve Jobs would proudly say,
# "It's fantastic."

# TheOpenAIR is an absolute game-changer, seamlessly integrating GPT
# models into your R workflows. Imagine the boundless possibilities this
# brings. With TheOpenAIR, you can effortlessly generate natural language
# text, automate content creation, and create engaging chatbots that
# amaze and captivate your audience.

# But what sets TheOpenAIR apart is its ease of use. It is designed for
# every data scientist, whether a novice or an expert. With a clean and
# intuitive interface, you can quickly unleash the power of GPT models
# without stress or complexity. Prepare to be amazed as the world of AI
# is brought within your grasp.

# You may wonder, can something this fantastic be reliable? The answer is
# a resounding yes! TheOpenAIR is built on a foundation of robustness and
# precision, leveraging the expertise of GPT models. It's like having an
# intelligent assistant with you at all times, providing accurate and
# insightful results.

# But that's not all - TheOpenAIR is highly flexible and extensible,
# empowering you to customize and fine-tune models according to your
# specific needs. It seamlessly integrates with your existing R
# workflows, making it an indispensable tool for any data scientist.

# Picture the immense potential and enhanced productivity that awaits you
# with TheOpenAIR. From generating personalized recommendations to
# automating complex data analyses, this package delivers exceptional
# results that will leave you in awe. It's time to unlock the
# extraordinary possibilities of machine learning with TheOpenAIR.

# In conclusion, TheOpenAIR is more than just a package; it's a gateway
# to limitless innovation. With its user-friendly interface, reliability,
# and flexibility, it transforms your R workflows into powerful AI
# engines. Brace yourself for a journey of unparalleled creativity and
# productivity. TheOpenAIR - where the power of machine learning meets
# the magic of R. It's fantastic!

chat("Now shorten the essay to 30 words.")
# Introducing TheOpenAIR: an R package integrating GPT models seamlessly.
# Generate text, automate content creation, and captivate audiences with
# ease. It's fantastic!


# `chat()` is useful for interactive mode.

# To develop short scripts or functions based on `TheOpenAIR`,
# use the infix function `%c%` to send messages to the model
# and indicate what output is required.

# output to console
"Remove all numeric characters from '5XC-2a09ujnap9o2q0MP'" %c% "message_to_console"
# XC-aujnapoqMP

# The `%c%` infix function sends a message to the ChatGPT API using the
# `chat()` function and returns the response in the specified output format.

# `message %c% output`

# - The `message` argument can be any character string containing a message to be sent to the ChatGPT API.

# - The `output`argument must be one of the following character strings:
#   - "message_to_console" (default)
#   - "message"
#   - "response_object"

# Example
if (FALSE) {
  # Send a message and assign the response to a variable
  response_var <- "Hello, ChatGPT!" %c% "message"
  
  # Print the response
  print(response_var)
  
  # Send a message and return the full response object
  response_obj <- "Hello, ChatGPT!" %c% "response_object"
  
  # Print the response
  print(response_obj)
  
  # Extract model from OpenAI API response
  model(response_obj)
  
  # Extract object information from OpenAI API response
  object(response_obj)
  
  # Extract messages content from OpenAI API response
  messages_content(response_obj)
  
  # Extract ID form OpenAI API response
  id(response_obj)
}


# Other useful functions are meant to help translate between R and other languages


## Convert Java code to R code ----
if (FALSE) {
  # Convert a simple Java code snippet to R
  java_code <- "public class HelloWorld {
                  public static void main(String[] args) {
                    System.out.println(\"Hello, World!\");
                  }         
                }"
  r_code <- java_to_r(java_code)
  cat(r_code)
  
  # Convert Java code from a file and save the result to an R file
  input_file <- "path/to/java_file.java"
  output_file <- java_to_r(input_file)
}


## Convert Python code to R code ----
if (FALSE) {
  # Convert a simple Python code snippet to R
  python_code <- "def hello_world():
                    print(\"Hello, World!\")"
  r_code <- python_to_r(python_code)
  cat(r_code)
  
  # Convert Python code from a file and save the result to an R file
  input_file <- "path/to/python_file.py"
  output_file <- python_to_r(input_file)
}

## Convert nested R code to pipe syntax ----

# The `nested_to_pipe(r, n_tokens_limit = 3000, ...)` function takes
# an R script containing traditional nested syntax R code and converts it to
# magrittr-style syntax, using the pipe operator `%>%`.

# It also validates the input and output code to ensure proper R syntax.

# Example
if (FALSE) {
  # Converting a character string
  input <- "result <- mean(sqrt(abs(rnorm(10, 0, 1))), na.rm = TRUE)"
  output <- nested_to_pipe(input)
  cat(output)
  
  # Converting a file
  # Create a temporary input file
  input_file <- tempfile(fileext = ".R")
  write("result <- mean(sqrt(abs(rnorm(10, 0, 1))), na.rm = TRUE)", input_file)
  
  
  # Convert the file using nested_to_pipe
  output_file <- nested_to_pipe(input_file)
  
  # Check the converted file content
  cat(readLines(output_file))
  
}


## Refactor R code with AI assistance ----

if (FALSE) {
  # Create a sample R function file
  cat("my_sum <- function(a, b) {", "return(a + b)", "}", file = "sample_function.R")
  
  # Refactor the R function and return the output
  refactored_function <- refactor(file = "sample_function.R")
  
}


## Write test for an R function ----

# Example
if (FALSE) {
  # Write test for an R function
  write_test(file = "sample_function.R")
}

# END