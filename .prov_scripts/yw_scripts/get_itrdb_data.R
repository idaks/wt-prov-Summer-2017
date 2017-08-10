
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
#@in study_region @desc the name of the region os study is passed as input.
#@in prediction_years @desc a numeric vector of years over which reconstruction is needed.

#@param calibration_years @desc A numeric vector of all required years
#@param label  @desc A character string naming the study area.
#@param raw_dir @desc A character string indicating where raw downloaded files should be put.
#@param extract_dir @desc A character string indicating where the extracted and cropped ITRDB dataset should be put.
#@param chronology_type @desc A character vector of chronology type identifiers. 
#@param measurement_type @desc A character vector of measurement type identifiers
#@param tree_buffer @desc Distance from original geometry to include in the new geometry.
#@param quadsegs @desc Number of line segments to use to approximate a quarter circle

#@out itrdb 
#@out selected_itrdb
#@out tracts_files
#@out metadata_file
#@out tracts_xml

#@begin create_shapefile_dir @desc create a direcorty for downloading the shapefiles for the study region.
#@in dir_name @as study_region
dir.create("GRCA", showWarnings = T, recursive = T)
#@out user_created_dir  @uri file:./{study_region}
#@end create_dir_shapefiles 

# download shapefile directory

#@begin download_shapefile_archive @desc download the zip file of the region which contains the boundary, tracts, metadata.xml and nps_tracts.xml files.
#@in file_archive @as shapefile_archive
#@in dir @as user_created_dir 

FedData::download_data("http://nrdata.nps.gov/programs/Lands/GRCA_tracts.zip", destdir="./GRCA")

#@out compressed_shapefile   @uri file:./{study_region}/{study_region}_tracts.zip  
#@end download_shape_files


#@begin uncompress_shapefile @desc create a directory as the archive filename and extract the files.
#@in zipfile @as compressed_shapefile  
#@in dir_name @as user_created_dir
# uncompress shapefile directory
utils::unzip("./GRCA/GRCA_tracts.zip", exdir="./GRCA/grca_tracts")

#@out shapefiles_dir @uri file:./{study_region}/{study_region}_tracts
#@out layer_boundary @uri file:./{study_region}/{study_region}_tracts/{study_region}_boundary.{file_extensions}
#@out layer_tracts @as tracts_files @uri file:./{study_region}/{study_region}_tracts/{study_region}_tracts.{file_extensions}
#@out metadata_xml_file @as metadata_file @uri file:./{study_region}/{study_region}_tracts/{study_region}_metadata.xml
#@out tracts_xml_file @as tracts_xml  @uri file:./{study_region}/{study_region}_tracts/nps_tracts.xml 
#@end extract_shape_files



#@begin read_shapefile @desc read the shapefile for the region and save it as a spatial vector object.
#@in layer @as layer_boundary
#@in dir @as shapefiles_dir
# read shapefile
grca <- rgdal::readOGR("./GRCA/grca_tracts", layer='GRCA_boundary')


#@out dataobject @as spatial_dataframe 
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
#@in polygon @as spatial_dataframe 
#@param segment_approx @as quadsegs
#@out template  @as treepolygon 


## Get Tree-ring data from the ITRDB for 10-degree buffer around MVNP
# create a 10-degree buffer around the four corner states
treePoly <- suppressWarnings(rgeos::gBuffer(grca, width=tree.buffer, quadsegs=1000))
# extract the re-whitened residuals of the tree-ring chronologies

#@end get_treepolygon


#@begin extract_tree_ring_data @desc download all the tree ring chronologies and extract the values for the study region.

#@in polygon @as treepolygon
#@param label @as label
#@param raw.dir @as raw_dir @uri file:./{study_region}/RAW/
#@param extract.dir @as extract_dir @uri file:./{study_region}/ITRDB/
#@in recon_year @as prediction_years
#@param calib.years @as calibration_years
#@param measurement @as measurement_type
#@param filter  @as chronology_type

itrdb <- FedData::get_itrdb(template=treePoly, label="GRCA_PLUS_10DEG", raw.dir = "./GRCA/RAW/ITRDB/", extraction.dir = "./GRCA/ITRDB/", recon.years=prediction.years, 
                            calib.years=calibration.years, measurement.type="Ring Width", chronology.type="ARSTND")

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

#@out tree_ring_files @as itrdb @uri file:./{region_name}/{raw.dir}/ITRDB/itrdb-v705-{var}-crn.zip
#@out list @as selected_itrdb @uri file:./data/itrdb.Rda
#@end  extract_tree_ring_data

 
#@end get_itrdb_data