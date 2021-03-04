# Look up available versions at https://github.com/rocker-org/rocker-versioned/tree/master/verse

FROM rocker/verse:3.6.3

RUN install2.r --error \
    --skipinstalled \
    --deps TRUE \
    rmdfiltr

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libgsl0-dev \
    libnlopt-dev

# Install packages specified in DESCRIPTION
COPY DESCRIPTION /home/rstudio/
WORKDIR /home/rstudio/
RUN install2.r --error \
    --skipinstalled \
    --deps TRUE \
    --ncpus 3 \
    $(Rscript -e "pkg <- remotes:::load_pkg_description('.'); repos <- c('https://cloud.r-project.org', remotes:::parse_additional_repositories(pkg)); deps <- remotes:::local_package_deps(pkgdir = '.', dependencies = NA); write(paste0(deps[!deps %in% c('papaja')], collapse = ' '), stdout())") \
    && rm DESCRIPTION

# Required by broom -- obsolete once newer version are available from MRAN
RUN Rscript -e "remotes::install_version('rlang', '0.4.7', repos = 'http://cran.us.r-project.org', upgrade = FALSE, Ncpus = 3)"
RUN Rscript -e "remotes::install_version('tidyselect', '1.1.0', repos = 'http://cran.us.r-project.org', upgrade = FALSE, Ncpus = 3)"
RUN Rscript -e "remotes::install_version('vctrs', '0.3.2', repos = 'http://cran.us.r-project.org', upgrade = FALSE, Ncpus = 3)"
RUN Rscript -e "remotes::install_version('dplyr', '1.0.0', repos = 'http://cran.us.r-project.org', upgrade = FALSE, Ncpus = 3)"

# Latest papaja development version
RUN Rscript -e "remotes::install_github('crsh/papaja@devel',  quick = FALSE, build = TRUE, dependencies = c('Depends', 'Imports'), Ncpus = 3, upgrade = FALSE)"
