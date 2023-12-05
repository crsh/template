
# Libraries ---------------------------------------------------------------

library("targets")
library("tarchetypes")
library("rlang")
library("crew")

## Packages for project

project_packages <- c(
  "tibble"
  , "dplyr"
  , "tidyr"
)

# Make custom functions available -----------------------------------------

# source("R/hello.R")

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
  , controller = crew_controller_local(workers = 3) 
)

# ## Remote parallelized execution
# library("future")

# Sys.setenv(
#   PATH = paste0(
#     Sys.getenv("PATH")
#     , ":/usr/lib/rstudio-server/bin/postback"
#   )
# )

# methexp_labor_cluster <- methexp::methexp_cluster(
#   master = "134.95.17.37"
#   , user = "computer"
#   , servants = c(paste0("134.95.17.", 62:64), "localhost")
#   , cores = 1L
# )

# future::plan(future::cluster, workers = methexp_labor_cluster)


# Define plan -------------------------------------------------------------

list(
  tar_target(test, 1+1)
  , tar_target(test2, 2+2)

  # Render report
  , tar_render(
    report
    , "analysis1.Rmd"
    , deployment = "main"
    , quiet = TRUE
  )
)
