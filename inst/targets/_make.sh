#!/usr/bin/env Rscript

# Subset targets --------------------------------------------------------------

tbd_targets <- c(
  NULL
)


# Remote parallelized execution -----------------------------------------------

cluster <- TRUE

if(cluster) {
  library("future")

  Sys.setenv(
    PATH = paste0(Sys.getenv('PATH'), ':/usr/lib/rstudio-server/bin/postback')
  )

  methexp_labor_cluster <- methexp::methexp_cluster(
    master = "134.95.17.37"
    , user = "computer"
    , servants = c(paste0("134.95.17.", 62:64), "localhost")
    , cores = 1L
  )

  n_workers <- length(methexp_labor_cluster)

  future::plan(future::cluster, workers = methexp_labor_cluster)
} else {
  n_workers <- parallel::detectCores() -1
}



# Run targets plan (analyse data & build reports) -----------------------------

outdated_targets <- targets::tar_outdated()
targets_metadata <- targets::tar_meta()
rerun_time <- dplyr::filter(targets_metadata, name %in% outdated_targets)$seconds

cat(
  "\n\nPredicted computation time:"
  , targets:::format_seconds(sum(rerun_time, na.rm = TRUE))
  , "\n"
)

untimed_targets <- dplyr::filter(
  targets_metadata, name %in% outdated_targets && is.na(seconds)
)$name

cat(
  "\nTargets with nonestimable computation time estimate:"
  , if(nrow(untimed_targets) == 0) "None" else paste(untimed_targets, collapse = ", ")
  , "\n"
)

cat(paste("\nIt is now:  ", Sys.time()))

targets::tar_make_future(
  tbd_targets
  , workers = n_workers
)
