# this file is used for generating the prism data
# string of lat long values are input with the NetCDF file.
# A CSV file is generated as the output

# SEt this option to true for debugging only.
options(echo=FALSE)

args <- commandArgs(trailingOnly = TRUE)

##load the libraries for execution of the paleocar

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

## Get the coordinates into a matrix form for generating the required prism data file.

coord <- c(as.numeric(args[3]),as.numeric(args[2])) %>% # Longitude before latitude!
  matrix(ncol = 2)


## Call the prism_Data function for creating the csv file for the vectors
prism_data(coord,paste0("data/",args[4]), paste0("data/",args[5]))

cat("Success")

