
<!-- README.md is generated from README.Rmd. Please edit that file -->
methexp
=======

`methexp` contains functions for internal use in the Research Methods and Experimental Psychology group.

Installation
------------

You can install methexp from github with:

``` r
# install.packages("devtools")
devtools::install_github("methexp/methexp")
```

Example
-------

To set up a new project repository using our standard project structure see `init_project()`:

``` r
# Set up project structure
init_project(
  x = "new_project"
  , path = "~/Documents/projects"
  , git = TRUE
  , pkg_structure = FALSE
  , packrat = TRUE
)

# Start new study
add_study(x = "new_project")

# Start new manuscript
add_paper(
  x = "new_project"
  , shorttitle = "new_project_paper"
)
```
