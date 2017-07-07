
#@begin exec_paleocar
#@in coordinates
#@in netcdf_file @file {data_file}.nc @uri file:/data/{data_file}.nc
#@in chronologies 
#@in calibration.year
#@in prediction.year
#@out paleocar_models @uri  file:{run_id}/{run_count}/{label}.models.rds 
#@out prediction_model @uri  file:{run_id}/{run_count}/{label}.prediction.rds 
#@out uncertainty_model @uri  file:{run_id}/{run_count}/{label}.uncertainty.rds 

    #@begin gen_prism_data
    #@in coordinates
    #@in netcdf_file
    
    #@out prism_data @uri file:data/{data_file}.csv 
    #@end gen_prism_data
    
    #@begin get_itrdb_data
    #@in calibration.years
    #@in prediction.years
    #@in tree.buffer
    #@in prism_data 
    
    #@begin get_treepolygon
    #@in prism_data  
    #@in width @as tree.buffer
    #@out treepolygon 
    #@end get_treepolygon

    #@begin get_itrdb
    #@in recon.years @as prediction.years
    #@in calib.yearr @as calibration.years
    #@in template @as treepolygon 
    #@param label 
    #@param measurement.type 
    #@param chronology.type 
    
    
    #@out itrdb 
    #@end get_itrdb 
    
    #@out itrdb 
    #@end get_itrdb_data

    #@begin paleocar_model

    #@in chronologies @as itrdb @desc A matrix of tree ring chronologies, indexed annually. Each chronology is a column. The first column must be labeled "YEAR" and is the calendar year.
    #@in predictands  @as prism_data @file 112W36N.csv @desc A RasterBrick, RasterStack, matrix, or vector of the numeric predictand (response) variable.
    #@in calibration.year @as calibration.year @desc An integer vector of years corresponding to the layers in the \code{predictands} brick.
    #@in prediction.year  @as prediction.year  @desc An optional integer vector of years for the reconstruction.
    
    #@param min_width @as min.width @desc An integer, indicating the minimum number of tree-ring samples allowed for that year of a chronology to be valid.
    #@param verbose @desc Logical, display status messages during run.

    #@out paleocar_models @uri  file:{run_id}/{run_count}/{label}.models.rds     
    #@end paleocar_model

    #@begin paleocar_predict_model 
    #@in paleocar_models @uri  file:{run_id}/{run_count}/{label}.models.rds 
    #@in prediction.year @as prediction.year 
    
    #@out prediction_model @uri  file:{run_id}/{run_count}/{label}.prediction.rds
    #@end paleocar_predict_model


    
    #@begin uncertainty_paleocar_model 
    #@in paleocar_models @uri  file:{run_id}/{run_count}/{label}.models.rds 
    #@in prediction.year @as prediction.year
    
    #@out model @as uncertainty_model  @uri file:{run_id}/{run_count}/{label}.uncertainty.rds 
    #@end uncertainty_paleocar_model
    

#@end exec_paleocar 

