
<!-- README.md is generated from README.Rmd. Please edit that file -->

# methexp

`methexp` contains functions for internal use in the Research Methods
and Experimental Psychology group.

## Installation

You can install methexp from github with:

``` r
# install.packages("remotes")
remotes::install_github("crsh/template")
```

## Example

To set up a new project repository using our standard project structure
see `init_project()`:

``` r
library("template")

# Set up project structure in temporary directory
tmp_dir <- tempfile("template-")

init_project(
  x = "myproject"
  , path = tmp_dir
  , pkg_structure = TRUE
  , drake = FALSE
  , targets = FALSE
  , docker = TRUE
  , git = TRUE
)

project_path <- file.path(tmp_dir, "myproject")

# Start another study
add_study(x = project_path)

# Start new manuscript
add_paper(
  x = project_path
  , shorttitle = "myproject-paper"
)
```

The resulting directory structure is looks like this:

                             levelName
    1  myproject/                     
    2   ¦--data/                      
    3   ¦--data-raw/                  
    4   ¦   ¦--myproject1/            
    5   ¦   °--myproject2/            
    6   ¦--inst/                      
    7   ¦   °--CITATION               
    8   ¦--myproject1/                
    9   ¦   ¦--material/              
    10  ¦   °--results/               
    11  ¦       °--analysis1.Rmd      
    12  ¦--myproject2/                
    13  ¦   ¦--material/              
    14  ¦   °--results/               
    15  ¦       °--analysis2.Rmd      
    16  ¦--paper/                     
    17  ¦   °--myproject-paper/       
    18  ¦       ¦--submissions/       
    19  ¦       °--myproject-paper.Rmd
    20  ¦--presentations/             
    21  ¦--R/                         
    22  ¦--tests/                     
    23  ¦   ¦--testthat/              
    24  ¦   °--testthat.R             
    25  ¦--.git/                      
    26  ¦   °-- ...                   
    27  ¦--_run_container.sh          
    28  ¦--DESCRIPTION                
    29  ¦--Dockerfile                 
    30  ¦--LICENSE.md                 
    31  ¦--myproject.Rproj            
    32  ¦--NAMESPACE                  
    33  ¦--README.Rmd                 
    34  ¦--.gitignore                 
    35  °--.Rbuildignore              
