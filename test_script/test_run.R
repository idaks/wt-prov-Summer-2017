
args <- commandArgs(trailingOnly = TRUE)

library(wrapperpaleocar)
library(paleocar)
library(magrittr)
library(raster)
library(magrittr)
library(tibble)
library(readr)

source("D:\\Study\\Internship\\WT_PaleoCar_2017\\meteor_example\\paloecar1\\Rscript\\wrapper_paleocar.R")

reg_boundary(args[1])

coord <- c(as.numeric(args[2]),as.numeric(args[1])) %>% # Longitude before latitude!
  matrix(ncol = 2)
prism_data(coord,args[1],"D:\\rough\\112W36N_out.csv")


#
# coord <- c(as.numeric(args[2]),as.numeric(args[1])) %>% # Longitude before latitude!
#   matrix(ncol = 2)
#
# ## For Testing
# ##coord <- c(-112,36) %>% # Longitude before latitude!
# ##  matrix(ncol = 2)
#
#
# prism_data(coord,"D:\\rough\\112W36N.nc","D:\\rough\\112W36N_out.csv")
# print(reg_boundary("D:\\rough\\112W36N.nc"))
#
#
# # Load spatial polygon for the boundary of Mesa Verde National Park (mvnp) in southwestern Colorado:
# data(mvnp)
# # Get Tree-ring data from the ITRDB for 10-degree buffer around mvnp
# data(itrdb)
# # Get 1/3 arc-second PRISM gridded data for the mvnp north study area (water-year [October--September] precipitation, in millimeters)
# data(mvnp_prism)
#
#
# # Extract a matrix of annualized climate data (all cells in the raster)
# mvnp_prism.matrix <- mvnp_prism %>%
#   raster::as.matrix() %>%
#   t()
#
# # Print to show format
# mvnp_prism.matrix %>%
#   tibble::as_tibble()
#
#
# ## Read the CSV file
# grca_prism=read.csv("D:\\rough\\112W36N_out.csv")
#
# ## convert it into a vector
# grca_prism <- grca_prism[,1]
#
# ## execute paleocar for a single region
# run_paleocar(testDir="D:\\Study\\Internship\\WT_PaleoCar_2017\\paleocar\\paleocar_test\\test3\\",
#              grca_prism,
#              label="grca_prism",
#              itrdb = itrdb,
#              calibration.years=1924:1983,
#              prediction.years=1:2000,
#              verbose=T,
#              input_data_type = "v")
# #
# # ## execute paleocar for multiple region
# # run_paleocar(testDir="D:\\Study\\Internship\\WT_PaleoCar_2017\\paleocar\\paleocar_test\\test2\\",
# #              mvnp_prism.matrix,
# #              label="mvnp_prism.matrix",
# #              itrdb = itrdb,
# #              calibration.years=1924:1983,
# #              prediction.years=1:2000,
# #              verbose=T,
# #              input_data_type = "m")
