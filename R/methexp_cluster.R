#' Create a Parallel Socket Cluster
#'
#' This convenience function creates a PSOCK cluster on our spare lab machines.
#' After finishing your computations, remember to \code{\link{parallel::stopCluster()}}.
#'
#' Before you can use the cluster, you need to copy your SSH key to the lab machines.
#' Ask \code{marius.barth@uni-koeln.de} for help.
#'
#' @param user Character. SSH user name on lab machines, needs to be created by admin.
#' @param master Character. IPv4 address of your own machine.
#'
#' @export

methexp_cluster <- function(user = "computer", master = "134.95.17.36") {

  if(missing(user) || is.null(user)) stop("Please provide a SSH user name.")
  if(missing(master) || is.null(master)) stop("Please provide a master IPv4 address.")

  addresses <- paste0("134.95.17.", c(2, 62:65))

  machineAddresses <- lapply(addresses, FUN = function(x) {
    list(host = x, user = user, ncore = 6L)
  })

  spec <- unlist(lapply(
    X = machineAddresses
    , FUN = function(x) {
      rep(list(list(
        host=x$host,
        user=x$user)),
        x$ncore)
    }), recursive = FALSE)

  parallel::makeCluster(
    master = master
    , spec = spec
  )
}
