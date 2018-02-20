
#' Set up new project repository
#'
#' Creates a folder structure and sets up basic functionality.
#'
#' @param x Character. Name of project repository.
#' @param path Character. Path to the folder that is to contain the project repository.
#' @param git Logical. Whether to initialize git.
#' @param pkg_structure Logical. Whether to add R-package infrastructure.
#' @param packrat Logical. Whether to use \pkg{packrat} to manage package dependencies.
#' @param ci Logical. Whether to set up continuous integration facilities.
#'
#' @export

init_project <- function(
  x
  , path = "."
  , git = TRUE
  , pkg_structure = FALSE
  , packrat = TRUE
  , ci = FALSE
) {
  assertthat::assert_that(is.character(x))
  assertthat::assert_that(is.character(path))
  assertthat::assert_that(assertthat::is.flag(git))
  assertthat::assert_that(assertthat::is.flag(pkg_structure))

  # Set up folder structure
  project_path <- path(path, x)
  paper_path <- path(project_path, "paper")
  r_path <- path(project_path, "R")
  poster_talk_path <- path(project_path, "talks_posters")
  grant_path <- path(project_path, "grants")

  if(pkg_structure) {
    devtools::create(project_path)
    devtools::use_testthat(project_path)
  } else {
    assertthat::assert_that(dir.create(project_path))
    dir.create(r_path)
  }

  if(git) devtools::use_git(pkg = project_path)
  if(packrat) packrat::init(
    project = project_path
    , enter = FALSE
    , options = list(auto.snapshot = FALSE)
  )

  add_study(project_path)
  assertthat::assert_that(dir.create(paper_path))
  assertthat::assert_that(dir.create(poster_talk_path))
  assertthat::assert_that(dir.create(grant_path))

  if(pkg_structure) {
    devtools::use_build_ignore(
      c(
        project_path
        , paste0(x, "\\d+")
        , paper_path
        , poster_talk_path
        , grant_path
      )
      , pkg = project_path
    )
  }

  devtools::use_readme_rmd(project_path)
  if(ci) {
    devtools::use_travis(project_path)
    devtools::use_appveyor(project_path)
  }
  assertthat::assert_that(file.create(path(project_path, "LICENSE")))

  file.copy(
    from = system.file("rmd", "README.Rmd", package = "methexp")
    , to = path(project_path, paste0("README.Rmd"))
  )

  invisible(TRUE)
}



#' Add a new study
#'
#' Set up directory structure for a new study in an existing project repository.
#'
#' @param x Character. Path to project repository.
#'
#' @export

add_study <- function(x = ".") {
  assertthat::assert_that(is.character(x))

  project_directories <- list.dirs(x, recursive = FALSE)
  studies <- grep("\\d+$", project_directories, value = TRUE)

  if(length(studies) > 0) {
    studies <- as.numeric(gsub(".+\\D(\\d+$)", "\\1", studies))
    new_study <- max(studies) + 1
  } else {
    new_study <- 1
  }

  study_path <- path(x, paste0(basename(x), new_study))
  results_path <- path(study_path, "results")

  assertthat::assert_that(dir.create(study_path))
  dir.create(path(study_path, "material"))
  dir.create(results_path)
  dir.create(path(results_path, "data_raw"))
  dir.create(path(results_path, "data_processed"))

  file.copy(
    from = system.file("rmd", "analysis.Rmd", package = "methexp")
    , to = path(results_path, paste0("analysis", new_study, ".Rmd"))
  )

  basename(study_path)
}



#' Add a new paper
#'
#' Set up directory structure for a new paper and adds a \pkg{papaja} template to
#' an existing project repository.
#'
#' @inheritParams add_study
#' @param shorttitle Character. Short title of the paper used as directory name.
#'
#' @export

add_paper <- function(x = ".", shorttitle) {
  assertthat::assert_that(is.character(x))
  assertthat::assert_that(is.character(shorttitle))

  paper_path <- path(x, "paper", shorttitle)
  assertthat::assert_that(dir.create(paper_path))
  assertthat::assert_that(dir.create(path(paper_path, "submissions")))

  rmarkdown::draft(
    path(paper_path, paste0(shorttitle, ".Rmd"))
    , "apa6"
    , package = "papaja"
    , create_dir = FALSE
    , edit = FALSE
  )

  invisible(paper_path)
}

