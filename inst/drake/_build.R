
# Run drake plan (analyse data & build reports) ---------------------------

roxygen2::roxygenise()
devtools::build(pkg = ".")

drake::r_make()
