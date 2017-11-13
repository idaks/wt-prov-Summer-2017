# this file is used for Execution of the PaleoCar function
# the details on the input are mentioned below
# The output of the execution are 3 files, generated in the test dir.
# Two are graphs and the other 1 is the log of the execution,

# SEt this option to true for debugging only.

options(echo=FALSE)
args <- commandArgs(trailingOnly = TRUE)
#print(args)

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

## load the tree ring chronologies
data(itrdb)

## set the input parameters

## set the test directory
testDir= paste0(args[2],"/")

## the prism data input
prism_data= paste0(testDir, args[3])

## label
label= args[4]

## the chronologies
chronologies=itrdb



## the calibration years
## For getting the values as year1:year2 as vector we need to split the string
## and formulate it as vector .
calibration.years <- as.numeric(unlist(strsplit(args[5], split=":")))[1]:as.numeric(unlist(strsplit(args[5], split=":")))[2]

## the prediction years
## For getting the values as year1:year2 as vector we need to split the string
## and formulate it as vector .
prediction.years <- as.numeric(unlist(strsplit(args[6], split=":")))[1]:as.numeric(unlist(strsplit(args[6], split=":")))[2]

## the verbose parameter for logging
verbose=args[7]


## the min_width parameter
min_width = ''

## input data type as vector, matrix or raster (v, m ,r)
input_data_type=args[8]


#@begin exec_paleocar @desc execute paleocar for reconstruction of paleoclimate of the study region. 
#@in prediction_years @desc period for reconstruction of the paleoclimate using paleocar. 
#@in prism_data_for_coordinates 
#@param itrdb
#@param calibration_years @desc period for calibrating the information for predicting the climate. 
#@param label 
#@param min_width 
#@param verbose 


#@out prediction_model 
#@out prediction_plot  
#@out uncertainty_model  
#@out uncertainty_plot  
#@out paleocar_log_file 

#@begin gen_paleocar_model @desc execute paleocar for reconstruction of paleoclimate of the study region. 
#@in prediction_years @desc period for reconstruction of the paleoclimate using paleocar. 
#@in prism_data_for_coordinates @uri file:.output/{session_id}/{run_id}/112W36N.csv 
#@param itrdb @file 112W36N.nc @uri file:data/itrdb.Rda @desc tree ring chronologies database
#@param calibration_years @desc period for calibrating the information for predicting the climate. 
#@param label @desc user entered label for the study region. 
#@param min_width @desc min width of the tree rings. 
#@param verbose @desc set to true for writing output to a logfile. 


#@out prediction_model @uri  file:.output/{session_id}/{run_id}/{label}_prediction.Rds  
#@out prediction_plot   @uri file:.output/{session_id}/{run_id}/{label}_predictions.jpg    
#@out uncertainty_model @uri file:.output/{session_id}/{run_id}/{label}_uncertainty.Rds 
#@out uncertainty_plot  @uri file:.output/{session_id}/{run_id}/{label}_uncertainty.jpg 
#@out paleocar_log_file @uri file:.output/{session_id}/{run_id}/paleocar_model_log.txt  
#@end gen_paleocar_model


## Check if input_data_type is a vector and execute the paleocar
if(input_data_type=="v")
{

  prism_data = read.csv(prism_data, header = TRUE)
  prism_data = prism_data[,1]

  run_paleocar(  testDir,
                 prism_data,
                 label,
                 chronologies,
                 calibration.years=calibration.years,
                 prediction.years=prediction.years,
                 verbose=verbose,
                 input_data_type = "v",
				 min_width
				 
  )
}


#@end exec_paleocar
## Check if input_data_type is a matrix and execute the paleocar

if(input_data_type=="m"){

  predictands = read.csv(prism_data, header = TRUE)
  predictands.matrix <- predictands %>%
    raster::as.matrix() %>%
    t()

  # Print to show format
  predictands.matrix %>%
    tibble::as_tibble()


  run_paleocar(  testDir,
                 predictands.matrix,
                 label,
                 chronologies,
                 calibration.years,
                 prediction.years,
                 verbose,
                 "m"
  )
}

## Check if input_data_type is a raster and execute the paleocar

if(input_data_type=="r")
{
  predictands = prism_data

  run_paleocar(  testDir,
                 predictands,
                 label,
                 chronologies,
                 calibration.years,
                 prediction.years,
                 verbose,
                 "r"
  )
}

cat(2)


