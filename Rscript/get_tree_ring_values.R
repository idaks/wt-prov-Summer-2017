# For testing the script if you want see commands on server terminal
# set techo=True
options(echo=FALSE)

## this option is used for taking the inputs from command line.

args <- commandArgs(trailingOnly = TRUE)

## Print the args for testing if needed.

# print(args)

## load the librariers.
library(paleocar)
library(magrittr)
library(raster)
library(magrittr)
library(tibble)
library(readr)


## get the rds file 
model_rds_file= paste0(args[2])


calibration_year=args[3]

output_file=args[4]


model <-readRDS(model_rds_file)

setwd(args[1])

#@begin get_tree_ring_values @desc extract the values of the tree ring chronologies used for reconstruction for a given year
#@in paleocar_models 
#@in calibration_year 
#@out tree_ring_values 
#label='GRCA'
	#@begin extract_tree_ring_values
	#@in models @as paleocar_models   @uri  file:.output/{session_id}/{run_id}/{label}_model.Rds
	#@in calibration_year
	#@out tree_ring_values @uri file:.output/{session_id}/{run_id}/{calibration_year}_tree_ring_data.csv

data.frame(x=names(model$predictor.matrix[calibration_year,]),
           y=as.numeric(model$predictor.matrix[calibration_year,])) %>%
		   write_csv(output_file)

	#@end extract_tree_ring_values

#@end get_tree_ring_values 

