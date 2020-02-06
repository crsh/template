
# Make custom functions available -----------------------------------------

# roxygen2::roxygenise()
# devtools::install(pkg = ".", upgrade = "never")


# Run drake plan (analyse data & build reports) ---------------------------

cat("\n\nPredicted computation time:", drake::r_predict_runtime(source = "_drake_config.R"), "\n")

# drake::r_vis_drake_graph(source = "_drake_config.R")
# drake::r_outdated(source = "_drake_config.R")

drake::r_make(source = "_drake_config.R")
