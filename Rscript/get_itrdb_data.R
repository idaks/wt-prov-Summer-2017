
# For testing th script if you want see commands on server terminal
# set techo=True
options(echo=FALSE)

## this option is used for taking the inputs from command line.

args <- commandArgs(trailingOnly = TRUE)

## Print the args for testing if needed.

# print(args)


## load the librariers.

library(FedData)
setwd("D:\\Study\\Internship\\WT_PaleoCar_2017\\meteor_example\\wt-prov-summer-2017\\data")


##### GRCA Spatial Polygon

#@begin get_itrdb_data @desc get the tree ring chronologies for reconstruction of the paleoclimate. 
#@in shapefile_archive   @uri http://nrdata.nps.gov/programs/Lands/{study_region}_tracts.zip
#@in study_region
#@in prediction_years
#@out itrdb 

study_region="GRCA"

#@begin create_shapefile_dir @desc create a direcorty for downloading the shapefiles for the study region.
#@in dir_name @as study_region
dir.create("GRCA", showWarnings = T, recursive = T)
#@out user_created_dir  @uri file:data/{study_region}
#@end create_dir_shapefiles 

# download shapefile directory

#@begin download_shapefile_archive @desc download the zip file of the region which contains the boundary, tracts, metadata.xml and nps_tracts.xml files.
#@in file_archive @as shapefile_archive
#@in dir @as user_created_dir 

FedData::download_data("http://nrdata.nps.gov/programs/Lands/GRCA_tracts.zip", destdir="./GRCA")

#@out compressed_shapefile   @uri file:data/{study_region}/{study_region}_tracts.zip  
#@end download_shape_files


#@begin uncompress_shapefile @desc create a directory as the archive filename and extract the files.
#@in zipfile @as compressed_shapefile  
#@in dir_name @as user_created_dir
# uncompress shapefile directory
study_region="GRCA"
utils::unzip("./GRCA/GRCA_tracts.zip", exdir="./GRCA/grca_tracts")

#@out shapefiles_dir @uri file:data/{study_region}/{study_region}_tracts
#@out layer_boundary @uri file:data/{study_region}/{study_region}_tracts/{study_region}_boundary.{file_extensions}
#@out layer_tracts @uri file:data/{study_region}/{study_region}_tracts/{study_region}_tracts.{file_extensions}
#@out metadata_xml_file @uri file:data/{study_region}/{study_region}_tracts/{study_region}_metadata.xml
#@out tracts_xml_file @uri file:data/{study_region}/{study_region}_tracts/nps_tracts.xml 
#@end extract_shape_files



#@begin read_shapefile @desc read the shapefile for the region and save it as a spatial vector object.
#@in layer @as layer_boundary
#@in dir @as shapefiles_dir
# read shapefile
grca <- rgdal::readOGR("./GRCA/grca_tracts", layer='GRCA_boundary')


#@out dataobject @as dataframe 
#@end read_shapefile 

#grca <- rgdal::writeOGR(grca, dsn = "./GRCA", layer = "grca", driver = "ESRI Shapefile", overwrite_layer = TRUE)



##### ITRDB DATA For GRCA 


## Set the calibration period
# Here, we use a 60 year period ending at 1983 
# to maximize the number of dendro series.
calibration.years <- 1924:1983 

## Set the retrodiction years (AD)
prediction.years <- 1:2000

## Set a spatial buffer around the area you wish to reconstruct
## from which to grab tree-ring chronologies. This will probably
## be in degrees.
tree.buffer <- 10

#@begin get_treepolygon @desc Get Tree-ring data from the ITRDB for tree_buffer around GRCA
#@in width @as tree_buffer
#@in polygon @as dataframe 
#@in quadsegs @as segments_approx_quarter_circle
#@out template  @as treepolygon 


## Get Tree-ring data from the ITRDB for 10-degree buffer around MVNP
# create a 10-degree buffer around the four corner states
treePoly <- suppressWarnings(rgeos::gBuffer(grca, width=tree.buffer, quadsegs=1000))
# extract the re-whitened residuals of the tree-ring chronologies

#@end get_treepolygon


#@begin extract_tree_ring_data @desc get all the tree ring chronologies and extract the values for the study region.
#@in polygon @as treepolygon
#@param label 
#@param raw_dir @uri file:data/{study_region}/RAW/
#@param extraction_dir @uri file:data/{study_region}/ITRDB/
#@in prediction_years
#@param calib_years @as calibration_years
#@param measurement_type 
#@param chronology_type 
#@param force_redo 

itrdb <- FedData::get_itrdb(template=treePoly, label="GRCA_PLUS_10DEG", raw_dir = "./GRCA/RAW/ITRDB/", extraction_dir = "./GRCA/ITRDB/", recon_years=prediction.years, 
                            calib_years=calibration.years, measurement.type="Ring Width", chronology.type="ARSTND", force_redo = TRUE)

#unlink("./data-raw/ITRDB_GRCA", recursive = T)

Encoding(levels(itrdb$metadata$NAME)) <- "latin1"
levels(itrdb$metadata$NAME) <- iconv(
  levels(itrdb$metadata$NAME), 
  "latin1", 
  "UTF-8"
)

Encoding(levels(itrdb$metadata$CONTRIBUTOR)) <- "latin1"
levels(itrdb$metadata$CONTRIBUTOR) <- iconv(
  levels(itrdb$metadata$CONTRIBUTOR), 
  "latin1", 
  "UTF-8"
)

#devtools::use_data(itrdb, overwrite = TRUE)

readr::write_rds(itrdb,
                 "itrdb.Rda",
                 compress = "gz")


#@out list @as itrdb @uri file:data/itrdb.rda
#@end  extract_tree_ring_data

 
#@end get_itrdb_data