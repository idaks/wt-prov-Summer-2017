#@begin get_itrdb_data @desc Get tree ring data for 10 deg width buffer using shapefile and for 60 years (1924:1983)


#@in prediction_year @as prediction.year

#@in shapefile_archive   @uri http://nrdata.nps.gov/programs/Lands/grca_tracts.zip
#@in user_label_itrdb 
#@param calibration_year @as calibration.year
#@param tree_buffer @uri 10_degree_buffer_around_the_area


#@out ITRDB 


#@begin get_shapefile @desc download shapefile archive and extract the shapefile for the grca region.
#@in spatial_polygon @as shapefile_archive

#@out polygon_shape @as shapefile  @uri file:/data-raw/grca.shx
#@end get_shapefile 

#@param label 
#@param measurement_type
#@param chronology_type 
    
    #@begin get_treepolygon @desc Get Tree-ring data from the ITRDB for tree_buffer around GRCA
    #@in width @as tree_buffer
    #@in polygon @as shapefile 
    #@out treepolygon  @as treepolygon
    
    #@end get_treepolygon

#@begin get_tree_ring_data  @desc Extract tree ring data for the grca region using get_itrdb function and  treepolygon template.
#@in treepolygon 
#@param label @as user_label_itrdb 
#@param measurement_type
#@param chronology_type 
#@out itrdb  @as ITRDB @uri file:/data/itrdb.Rda
#@end get_itrdb

#@end get_itrdb_data 