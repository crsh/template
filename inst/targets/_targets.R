
# Libraries ---------------------------------------------------------------

library("targets")
library("tarchetypes")
library("rlang")

## Packages for project

project_packages <- c(
  "tibble"
  , "dplyr"
  , "tidyr"
)

# Make custom functions available -----------------------------------------

source("R/hello.R")

# roxygen2::roxygenise()
# devtools::install(pkg = ".", upgrade = "never")


# Configure plan execution ------------------------------------------------

options(tidyverse.quiet = TRUE)

tar_option_set(
  packages = project_packages
  , storage = "main"
  , retrieval = "main"
  , memory = "transient"
  , garbage_collection = TRUE
  , error = "continue"
  , workspace_on_error = TRUE
)


# Define plan -------------------------------------------------------------

list(
  tar_target(test, 1+1)
  , tar_target(test2, 2+2)

  # Render report
  , tar_render(
    report
    , "report.Rmd"
    , deployment = "main"
    , quiet = TRUE
  )
)
