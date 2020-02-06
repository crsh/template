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
#' @param cores Integer. The number of cores per servant host.
#'
#' @export

methexp_cluster <- function(
  user = "computer"
  , master = "134.95.17.36"
  , servants = paste0("134.95.17.", 62:65)
  , cores = 6L
) {

  if(is.null(user)) stop("Please provide a SSH user name.")
  if(is.null(master)) stop("Please provide a master IPv4 address.")
  if(is.null(cores) || is.na(cores)) cores <- 6L

  addresses <- servants

  machineAddresses <- lapply(addresses, FUN = function(x) {
    list(host = x, user = user, cores = cores)
  })

  spec <- unlist(lapply(
    X = machineAddresses
    , FUN = function(x) {
      rep(list(list(
        host=x$host,
        user=x$user)),
        x$cores)
    }), recursive = FALSE)

  parallel::makeCluster(
    master = master
    , spec = spec
  )
}
