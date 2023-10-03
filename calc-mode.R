set.seed(37)

probs <- c(0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.5, 0.05, 0.05, 0.1)
sum(probs)
# 1

vec_n <- sample(x = 1:10, size = 10000, replace = TRUE, prob = probs)

# return a function to calculate the mode of a vector
calc_mode <- function(x) {
  # get the unique values
  x_unique <- unique(x)
  
  # get the counts of each unique value
  x_counts <- tabulate(match(x, x_unique))
  
  # get the index of the max count
  max_count_index <- which.max(x_counts)
  
  # return the value with the max count
  x_unique[max_count_index]
}

calc_mode(vec_n)
# 7