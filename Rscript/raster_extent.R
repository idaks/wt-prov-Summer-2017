# this file is used for generating the boudary region
# the NetCdf file is used for input and
# string of lat long values is returned.

# SEt this option to true for debugging only.
options(echo=FALSE)
args <- commandArgs(trailingOnly = TRUE)

## load the libraries.

library(paleocar)
library(magrittr)
library(raster)
library(magrittr)
library(tibble)
library(readr)


#set the current project directory and
# source the wrapper function files.
setwd(args[1])
source("Rscript/wrapper_paleocar.R")


## Call reg_boundary location for getting  the extent values.

reg_boundary(paste0("data/",args[2]))

