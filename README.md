
<!-- README.md is generated from README.Rmd. Please edit that file -->
methexp
=======

`methexp` contains functions for internal use in the Research Methods and Experimental Psychology group.

Installation
------------

You can install methexp from github with:

``` r
# install.packages("devtools")
devtools::install_github("methexp/methexp")
```

Example
-------

To set up a new project repository using our standard project structure see `init_project()`:

``` r
# Set up project structure in temporary directory
tmp_dir <- tempfile("methexp-")

init_project(
  x = "newproject"
  , path = tmp_dir
  , git = TRUE
  , pkg_structure = TRUE
  , packrat = TRUE
  , ci = TRUE
)

project_path <- path(tmp_dir, "newproject")

# Start another study
add_study(x = project_path)

# Start new manuscript
add_paper(
  x = project_path
  , shorttitle = "newproject_paper"
)
```

The resulting directory structure is looks like this:

                              levelName
    1  newproject/                     
    2   ¦--grants/                     
    3   ¦--newproject1/                
    4   ¦   ¦--material/               
    5   ¦   °--results/                
    6   ¦       ¦--data_processed/     
    7   ¦       ¦--data_raw/           
    8   ¦       °--analysis1.Rmd       
    9   ¦--newproject2/                
    10  ¦   ¦--material/               
    11  ¦   °--results/                
    12  ¦       ¦--data_processed/     
    13  ¦       ¦--data_raw/           
    14  ¦       °--analysis2.Rmd       
    15  ¦--packrat/                    
    16  ¦   °-- ...                    
    17  ¦--paper/                      
    18  ¦   °--newproject_paper/       
    19  ¦       ¦--submissions/        
    20  ¦       °--newproject_paper.Rmd
    21  ¦--R/                          
    22  ¦--talks_posters/              
    23  ¦--tests/                      
    24  ¦   ¦--testthat/               
    25  ¦   °--testthat.R              
    26  ¦--.git/                       
    27  ¦   °-- ...                    
    28  ¦--appveyor.yml                
    29  ¦--DESCRIPTION                 
    30  ¦--LICENSE                     
    31  ¦--NAMESPACE                   
    32  ¦--newproject.Rproj            
    33  ¦--README.Rmd                  
    34  ¦--.gitignore                  
    35  ¦--.Rbuildignore               
    36  ¦--.Rprofile                   
    37  °--.travis.yml
