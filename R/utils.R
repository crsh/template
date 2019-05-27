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
