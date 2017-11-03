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

#@begin get_species_of_trees @desc extract the species of trees  used for reconstruction for prediction year
#@in paleocar_models   
#@in itrdb 

#@out tree_species_used
## get the rds file 
model_rds_file= paste0(args[2])


calibration_year=args[3]

output_file=args[4]


model <-readRDS(model_rds_file)

setwd(args[1])

#@begin  extract_tree_species 
#@in itrdb @uri file:data/itrdb.Rda
#@in paleocar_models @uri  file:.output/{session_id}{run_id}/{label}_models.rds 

#@out tree_species_used @uri  file:.output/{session_id}{run_id}/tree_species.csv 

# data.frame(grca_vector$reconstruction.matrix[prediction.years] )%>%
#   write_csv("reconst_matrix.csv")

# exportJSON <- toJSON(grca_vector$models)

itrdb$metadata[itrdb$metadata$SERIES %in% names(model$predictor.matrix[1,]),1:3] %>% 
  write_csv(output_file)

#@end extract_tree_species

#@end get_species_of_trees 

