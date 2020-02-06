expose_imports()


# Assamble drake plan -----------------------------------------------------

project_plan <- drake::drake_plan(a = 1 + 1)


# Configure drake ---------------------------------------------------------

options(mc.cores = parallel::detectCores() - 1)
# options(clustermq.scheduler = "multicore") # optional parallel computing
# future::plan(future.callr::callr(workers = future::availableCores() - 1))

rstan::rstan_options(auto_write = TRUE)

project_drake_env <- new.env(parent = globalenv())

project_drake_config <- drake::drake_config(
  project_plan
  , verbose = 2
  , cache = drake::drake_cache("drake_cache")
  , envir = project_drake_env
  , history = TRUE
  # , parallelism = "clustermq"
  , jobs = getOption("mc.cores")
  , jobs_preprocess	= 1
  , prework = character(0)
  , log_progress = TRUE
  , caching = "master"
  , keep_going = TRUE
  , history = TRUE
)

# drake::vis_drake_graph(project_drake_config)
# drake::outdated(project_drake_config)

project_drake_config
