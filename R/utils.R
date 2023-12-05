add_gitignore <- function(x, path, quiet = FALSE) {
  assertthat::assert_that(is.character(x))
  assertthat::assert_that(is.character(path))

  ignore_path <- file.path(path, ".gitignore")

  paths <- paste0("`", x, "`", collapse = ", ")
  if (!quiet) {
    message("* Adding ", paths, " to ", ignore_path)
  }

  path <- ignore_path
  writeLines(x, path)

  invisible(TRUE)
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

init_targets <- function(x, path = ".", git, pkg_structure) {
  targets_files <- c("_targets.yaml", "_make.sh")

  file.copy(
    from = system.file("targets", targets_files, package = "template")
    , to = "."
    , overwrite = FALSE
  )

  file.copy(
    from = system.file("targets", "_targets.R", package = "template")
    , to = file.path(path, paste0(x, "1"), "results")
    , overwrite = FALSE
  )

  usethis::use_package("targets")
  usethis::use_package("tarchetypes")
  usethis::use_package("rlang")

  if(git) {
    usethis::use_build_ignore(files = targets_files)
  }

  if(pkg_structure) {
    rproj_path <- paste0(x, ".Rproj")

    rproj <- readLines(rproj_path)
    rproj <- gsub(
      "BuildType: Package"
      , "BuildType: Custom\nCustomScriptPath: _make.sh"
      , rproj
    )
    writeLines(rproj, con = rproj_path)
  } else {
    cat(
      c(
        ""
        , "BuildType: Custom"
        , "CustomScriptPath: _make.sh"
      )
      , file = rproj_path
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
