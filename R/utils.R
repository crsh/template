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
#' @param x Character. Location at which to initialize drake workflow.
#' @inheritParams init_project
#'
#' @return
#' @export
#'
#' @examples

init_drake <- function(x = ".", git, pkg_structure) {
  drake_files <- c("_drake_config.R", "_build.R", "_build.sh")

  file.copy(
    from = system.file("drake", drake_files, package = "methexp")
    , to = file.path(x, drake_files)
    , overwrite = FALSE
  )

  drake::new_cache(file.path(x, "drake_cache"))
  usethis::use_r(name = "drake_plan")
  usethis::use_package("drake")

  if(git) {
    usethis::use_build_ignore(files = c(drake_files, "drake_cache"))
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