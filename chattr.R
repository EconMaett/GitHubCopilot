# chattr

remotes::install_github("mlverse/chattr")
library(chattr)

chattr::chattr_app()


data(mtcars)
data(iris)

chattr::chattr(preview = TRUE)
