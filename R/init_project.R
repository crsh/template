
#' Set up new project repository
#'
#' Creates a folder structure and sets up basic functionality.
#'
#' @param x Character. Name of project repository.
#' @param pkg_structure Logical. Whether to add R-package infrastructure.
#' @inheritParams usethis::create_package
#' @param git Logical. Whether to initialize git.
#' @param drake Logical. Whether to set up \pkg{drake} infrastructure.
#' @param targets Logical. Whether to set up \pkg{targets} infrastructure.
#' @param docker Logical. Whether to configure a default Docker container. For
#'   details see the
#'   \url[papaja manual]{http://frederikaust.com/papaja_man/tips-and-tricks.html#docker}
#'
#' @details When using \pkg{drake} keep the following in mind: First, customize
#'   \code{_drake_config.R} (e.g., remove or complete \code{expose_imports()}) and choose
#'   a parallelization approach. Parallelization requires the \pkg{future} package. Local
#'   parallelization should otherwise work out of the box. For parallelization on the
#'   Methexp cluster, set the right hostname or IP for \code{master} (i.e. your IP), and
#'   the cluster computers (these should be set to the correct static IP by default). If
#'   your \pkg{drake} targets perform parallel computations (e.g., MCMC chain parallelization
#'   in \pkg{rstan}), set \code{cores = 1L} in \code{methexp_cluster()} to avoid spawning
#'   too many jobs due to the nested parallelization. Make sure that all cluster computers
#'   have \pkg{future} and \pkg{drake} installed, otherwise you'll get hard-to-understand
#'   errors about missing packages or scheduler problems.
#'
#'   Finally, if you use \pkg{rstan}, you may want to compile your models first and sample
#'   in separate targets. If you parallelize on the Methexp cluster, you may want to compile
#'   locally by setting \code{hpc = FALSE} in the \pkg{drake} plan and set
#'   \code{rstan_options(auto_write = TRUE)} to avoid unnecessary model recompilation.
#'
#' @export

init_project <- function(
  x
  , path = "."
  , pkg_structure = TRUE
  , fields = NULL
  , git = TRUE
  , drake = FALSE
  , targets = FALSE
  , docker = TRUE
) {
  assertthat::assert_that(is.character(x))
  assertthat::assert_that(is.character(path))
  assertthat::assert_that(assertthat::is.flag(git))
  assertthat::assert_that(assertthat::is.flag(pkg_structure))

  # Set up folder structure
  if(!dir.exists(path)) dir.create(path)
  project_path <- file.path(path, x)
  paper_path <- "paper"
  r_path <- "R"
  poster_talk_path <- "presentations"

  wd <- getwd()

  if(pkg_structure) {
    if(is.null(fields)) {
      fields <- list(
        `Authors@R` = 'person(given = "Frederik", family = "Aust", role = c("aut", "cre"), comment = c(ORCID = "0000-0003-4900-788X"))',
        Language =  "en"
      )
    }

    usethis::create_package(
      project_path
      , open = FALSE
      , rstudio = TRUE
      , roxygen = TRUE
      , fields = fields
      , check_name = FALSE
    )


    setwd(project_path)
    usethis::use_testthat()
    setwd(wd)
  } else {
    assertthat::assert_that(dir.create(project_path))
    dir.create(r_path)
  }

  setwd(project_path)

  if(git) {
    usethis::use_git(message = "Sets up repository structure")

    add_gitignore(
      c(".Rproj.user", ".Rhistory", ".Ruserdata", ".DS_Store", "Thumbs.db", "*~$")
      , path = "."
    )
  }

  if(drake) {
    init_drake(x = x, git = git, pkg_structure = pkg_structure)
  }

  if(targets) {
    init_targets(x = x, git = git, pkg_structure = pkg_structure)
  }

  add_study()
  assertthat::assert_that(dir.create(paper_path))
  assertthat::assert_that(dir.create(poster_talk_path))

  if(git) {
    if(pkg_structure) {
      usethis::use_build_ignore(
        paste0("^", c(
          paste0(x, "\\d+")
          , "paper"
          , "talks_posters"
          , "grants"
        ), "$")
        , escape = FALSE
      )
      usethis::use_citation()
    }
  }

  if(docker) {
    file.copy(
      from = system.file("docker", "Dockerfile", package = "template")
      , to = "."
      , overwrite = FALSE
    )
    file.copy(
      from = system.file("docker", "_run_container.sh", package = "template")
      , to = "."
      , overwrite = FALSE
    )
  }

  usethis::use_ccby_license()

  add_readme(".")

  setwd(wd)

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

  if(!dir.exists(file.path(x, "data-raw"))) dir.create(file.path(x, "data-raw"))
  if(!dir.exists(file.path(x, "data"))) dir.create(file.path(x, "data"))

  study_name <- paste0(basename(x), new_study)
  study_path <- file.path(x, study_name)
  results_path <- file.path(study_path, "results")

  assertthat::assert_that(dir.create(study_path))
  dir.create(file.path(study_path, "material"))
  dir.create(results_path)
  dir.create(file.path(x, "data-raw", study_name))
  # dir.create(file.path(results_path, "data_processed"))

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

add_readme <- function(x = ".", name = NULL) {
  assertthat::assert_that(is.character(x))

  if(is.null(name)) {
    name <- "README.Rmd"
  } else {
    assertthat::assert_that(is.character(name))
  }

  file.copy(
    from = system.file("rmd", "README.Rmd", package = "template")
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

add_analysis <- function(x = ".", name = NULL) {
  assertthat::assert_that(is.character(x))

  if(is.null(name)) {
    name <- "analysis.Rmd"
  } else {
    assertthat::assert_that(is.character(name))
  }

  file.copy(
    from = system.file("rmd", "analysis.Rmd", package = "template")
    , to = file.path(x, name)
    , overwrite = FALSE
  )
}

