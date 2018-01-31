#' Concatenate strings to file path
#'
#' Concatenate vectors to file path after converting to character.
#'
#' @inheritParams base::paste
#'
#' @export
#'
#' @examples
#' path("foo", "bar")

path <- function(...) {
  paste(..., sep = "/")
}