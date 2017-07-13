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

# data.frame(grca_vector$reconstruction.matrix[prediction.years] )%>%
#   write_csv("reconst_matrix.csv")

# exportJSON <- toJSON(grca_vector$models)

data.frame(x=names(model$predictor.matrix[calibration_year,]),
           y=as.numeric(model$predictor.matrix[calibration_year,])) %>%
		   write_csv(output_file)

cat("generated tree ring data file ")
