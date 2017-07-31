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
#@begin gen_boundary_region
#@in user_map_marker_pos  @desc Coordinates of location for reconstruction of paleoclimate. 
#@param prism_data @file {data_file}.nc @uri file:/data/{data_file}.nc @desc file containing the precipitation values for the particular region

reg_boundary(paste0("data/",args[2]))
#@out boundary_coordinates @desc the lat and long values of the boundary region. 
#@end gen_boundary_region