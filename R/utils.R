add_gitignore <- function(x, path, quiet = FALSE) {
  assertthat::assert_that(is.character(x))
  assertthat::assert_that(is.character(path))

  paths <- paste0("`", x, "`", collapse = ", ")
  if (!quiet) {
    message("* Adding ", paths, " to ", file.path(path, ".gitignore"))
  }

  path <- file.path(path, ".gitignore")
  writeLines(x, path)

  invisible(TRUE)
}


#' Initialize \pkg{drake} workflow
#'
#' Sets up build files and creates a dedicated \pkg{drake} cache.
#'
#' @param x Character. Location at which to initialize \pkg{drake} workflow.
#' @inheritParams init_project
#'
#' @return
#' @export

init_drake <- function(x = ".", git, pkg_structure) {
  drake_files <- c("_drake_config.R", "_build.R", "_build.sh")

  file.copy(
    from = system.file("drake", drake_files, package = "template")
    , to = file.path(x, drake_files)
    , overwrite = FALSE
  )

  drake::new_cache(file.path(x, "drake_cache"))
  usethis::use_r(name = "drake_plan")
  usethis::use_package("drake")

  if(pkg_structure) {
    usethis::use_build_ignore(files = c(drake_files, "drake_cache", "drake.log"))
  }

  if(pkg_structure) {
    rproj <- readLines(file.path(x, paste0(basename(x), ".Rproj")))
    rproj <- gsub(
      "BuildType: Package"
      , "BuildType: Custom\nCustomScriptPath: _build.sh"
      , rproj
    )
    writeLines(rproj, con = file.path(x, paste0(basename(x), ".Rproj")))
  } else {
    cat(
      c(
        ""
        , "BuildType: Custom"
        , "CustomScriptPath: _build.sh"
      )
      , file = file.path(x, paste0(basename(x), ".Rproj"))
      , append = TRUE
    )
  }
}

#' Initialize \pkg{targets} workflow
#'
#' Sets up build files and creates a dedicated \pkg{targets} cache.
#'
#' @param x Character. Location at which to initialize \pkg{targets} workflow.
#' @inheritParams init_project
#'
#' @return
#' @export

init_targets <- function(x = ".", git, pkg_structure) {
  targets_files <- c("_targets.R", "_make.sh")

  file.copy(
    from = system.file("targets", targets_files, package = "template")
    , to = file.path(x, targets_files)
    , overwrite = FALSE
  )

  usethis::use_package("targets")
  usethis::use_package("tarchetypes")
  usethis::use_package("rlang")

  if(git) {
    wd <- getwd()
    setwd(file.path(wd, x))
    usethis::use_build_ignore(files = c(targets_files, "_targets"))
    setwd(wd)
  }

  if(pkg_structure) {
    rproj <- readLines(file.path(x, paste0(basename(x), ".Rproj")))
    rproj <- gsub(
      "BuildType: Package"
      , "BuildType: Custom\nCustomScriptPath: _make.sh"
      , rproj
    )
    writeLines(rproj, con = file.path(x, paste0(basename(x), ".Rproj")))
  } else {
    cat(
      c(
        ""
        , "BuildType: Custom"
        , "CustomScriptPath: _make.sh"
      )
      , file = file.path(x, paste0(basename(x), ".Rproj"))
      , append = TRUE
    )
  }
}


#' Get first author name
#'
#' Extracts first author name from DESCRIPTION
#'
#' @param ... Passed to \code{desc::desc_get}
#'
#' @return
#' @export

author_from_desc <- function(...) {
  author <- eval(parse(text = desc::desc_get(..., keys = "Authors@R")))
  author_name <- paste(unlist(unclass(author[[sapply(lapply(author, function(x) grepl("aut", x$role)), any)]])[[1]][c("given", "family")]), collapse = " ")
  author_name
}
