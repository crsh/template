drake::expose_imports()


# Assamble drake plan -----------------------------------------------------

project_plan <- drake::drake_plan(a = 1 + 1)


# Configure optional parallelization --------------------------------------

## Local paralellization
options(mc.cores = parallel::detectCores() - 1)
future::plan(future.callr::callr(workers = getOption("mc.cores")))

## Parallelization on Methexp cluster
# methexp_labor_cluster <- methexp::methexp_cluster(
#   user = "computer"
#   , master = "134.95.17.37"
#   , servants = paste0("134.95.17.", 62:65)
#   , cores = 1L
# )
#
# future::plan(future::cluster, workers = methexp_labor_cluster)


# Configure drake ---------------------------------------------------------

# rstan::rstan_options(auto_write = TRUE)

project_drake_env <- new.env(parent = globalenv())

project_drake_config <- drake::drake_config(
  project_plan
  , verbose = 2
  , cache = drake::drake_cache("drake_cache")
  , envir = project_drake_env
  , history = TRUE
  , keep_going = TRUE
  , log_progress = TRUE
  , console_log_file = "drake.log"

  ## Local parallelization
  , parallelism = "future"
  , jobs = getOption("mc.cores")

  ## Cluster parallelization
  # , parallelism = "future"
  # , jobs = length(methexp_labor_cluster)

  , jobs_preprocess	= 1
  , prework = character(0)
  , caching = "master"
)

project_drake_config
