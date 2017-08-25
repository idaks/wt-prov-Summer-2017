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

testDir=paste0(args[6],'/')

## Create the test directory in which the plots whould be generated
unlink(testDir)
dir.create(testDir, showWarnings=F, recursive=T)
## Get the coordinates into a matrix form for generating the required prism data file.

coord <- c(as.numeric(args[3]),as.numeric(args[2])) %>% # Longitude before latitude!
  matrix(ncol = 2)

#@begin extract_prism_data @desc Load the prism data file with precipitation values and extract the data for the input coordinates and save as a csv file.

#@in coordinates @desc Coordinates of location for reconstruction of paleoclimate. 
#@param prism_data  @desc file containing the precipitation values for the particular region. @uri data/112W36N.nc  

## Call the prism_Data function for creating the csv file for the vectors
prism_data(coord,paste0("data/",args[4]),paste0(testDir,args[5]))

#@out prism_data_for_coordinates @uri file:.output/{session_id}/{run_id}/112W36N.csv @desc file containing the precipitation values for the selected region.
#@end extract_prism_data


