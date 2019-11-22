
#' Set up new project repository
#'
#' Creates a folder structure and sets up basic functionality.
#'
#' @param x Character. Name of project repository.
#' @param path Character. Path to the folder that is to contain the project repository.
#' @param git Logical. Whether to initialize git.
#' @param pkg_structure Logical. Whether to add R-package infrastructure.
#' @param packrat Logical. Whether to use \pkg{packrat} to manage package dependencies.
# #' @param ci Logical. Whether to set up continuous integration facilities. Ignored if
# #'   \code{pkg_structure = FALSE}.
#'
#' @export

init_project <- function(
  x
  , path = "."
  , git = TRUE
  , pkg_structure = FALSE
  , packrat = TRUE
  # , ci = FALSE
) {
  assertthat::assert_that(is.character(x))
  assertthat::assert_that(is.character(path))
  assertthat::assert_that(assertthat::is.flag(git))
  assertthat::assert_that(assertthat::is.flag(pkg_structure))

  # Set up folder structure
  if(!dir.exists(path)) dir.create(path)
  project_path <- file.path(path, x)
  paper_path <- file.path(project_path, "paper")
  r_path <- file.path(project_path, "R")
  poster_talk_path <- file.path(project_path, "talks_posters")
  grant_path <- file.path(project_path, "grants")

  if(pkg_structure) {
    usethis::create_package(project_path, open = FALSE)
    usethis::use_testthat()
  } else {
    assertthat::assert_that(dir.create(project_path))
    dir.create(r_path)
  }

  if(git) {
    usethis::use_git(message = "Sets up repository structure")

    # if(pkg_structure & ci) {
    #   usethis::use_github()
    #   usethis::use_travis()
    #   usethis::use_appveyor()
    # } else {
    #   git2r::init(path = project_path)
      add_gitignore(
        c(".Rproj.user", ".Rhistory", ".Ruserdata", ".DS_Store", "Thumbs.db", "*~$")
        , path = project_path
      )
    # }
  }

  if(packrat) {
    packrat::init(
      project = project_path
      , enter = FALSE
      , options = list(auto.snapshot = FALSE)
    )
  }

  add_study(project_path)
  assertthat::assert_that(dir.create(paper_path))
  assertthat::assert_that(dir.create(poster_talk_path))
  assertthat::assert_that(dir.create(grant_path))

  if(pkg_structure) {
    usethis::use_build_ignore(
      c(
        project_path
        , paste0(x, "\\d+")
        , paper_path
        , poster_talk_path
        , grant_path
      )
    )
  }

  assertthat::assert_that(file.create(file.path(project_path, "LICENSE")))

  add_readme(project_path)

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

  study_path <- file.path(x, paste0(basename(x), new_study))
  results_path <- file.path(study_path, "results")

  assertthat::assert_that(dir.create(study_path))
  dir.create(file.path(study_path, "material"))
  dir.create(results_path)
  dir.create(file.path(results_path, "data_raw"))
  dir.create(file.path(results_path, "data_processed"))

  add_analysis(results_path, paste0("analysis", new_study, ".Rmd"))

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

  paper_path <- file.path(x, "paper", shorttitle)
  assertthat::assert_that(dir.create(paper_path))
  assertthat::assert_that(dir.create(file.path(paper_path, "submissions")))

  rmarkdown::draft(
    file.path(paper_path, paste0(shorttitle, ".Rmd"))
    , "apa6"
    , package = "papaja"
    , create_dir = FALSE
    , edit = FALSE
  )

  invisible(paper_path)
}

#' Add README from template
#'
#' Adds a README.Rmd file at the specified location
#'
#' @param x Character. Location at which to add a the file.
#' @param name Character. Name of the to-be-created file. Defaults to \code{README.Rmd}
#'
#' @return
#' @export
#'
#' @examples


add_readme <- function(x = ".", name = NULL) {
  assertthat::assert_that(is.character(x))

  if(is.null(name)) {
    name <- "README.Rmd"
  } else {
    assertthat::assert_that(is.character(name))
  }

  file.copy(
    from = system.file("rmd", "README.Rmd", package = "methexp")
    , to = file.path(x, name)
    , overwrite = FALSE
  )
}


#' Add analysis file from template
#'
#' Adds an new R Markdown file at the specified location
#'
#' @param x Character. Location at which to add a the file.
#' @param name Character. Name of the to-be-created file. Defaults to \code{analysis.Rmd}
#'
#' @return
#' @export
#'
#' @examples

add_analysis <- function(x = ".", name = NULL) {
  assertthat::assert_that(is.character(x))

  if(is.null(name)) {
    name <- "analysis.Rmd"
  } else {
    assertthat::assert_that(is.character(name))
  }

  file.copy(
    from = system.file("rmd", "analysis.Rmd", package = "methexp")
    , to = file.path(x, name)
    , overwrite = FALSE
  )
}
