
#@begin exec_paleocar
#@in coordinates
#@in netcdf_file @file 112W36N.nc
#@in itrdb 
#@in calibration.year
#@in prediction.year
#@out paleocar_model.rds
#@out prediction_graph @file /{run_id}/{run_count}/prediction.jpg 
#@out uncertainty_graph @file /{run_id}/{run_count}/uncertainty.jpg

    #@begin gen_prism_data
    #@in coordinates
    #@in netcdf_file
    
    #@out prism_data @file 112W36N.csv 
    #@end gen_prism_data

    #@begin paleocar_models
    #@in chronologies @as itrdb @desc A matrix of tree ring chronologies, indexed annually. Each chronology is a column. The first column must be labeled "YEAR" and is the calendar year.
    #@in predictands  @as prism_data @file 112W36N.csv @desc A RasterBrick, RasterStack, matrix, or vector of the numeric predictand (response) variable.
    #@in calibration.year @as calibration.year @desc An integer vector of years corresponding to the layers in the \code{predictands} brick.
    #@in prediction.year  @as prediction.year  @desc An optional integer vector of years for the reconstruction.
    #@param min_width @as min.width @desc An integer, indicating the minimum number of tree-ring samples allowed for that year of a chronology to be valid.
    #@param verbose @desc Logical, display status messages during run.

    #@out model @as paleocar_model.rds
    
    #@end paleocar_models
    
    #@begin paleocar_predict_model 
    #@in paleocar_interim_model @as paleocar_model.rds
    #@in prediction.year @as prediction.year
    #
    #@out image @as prediction_graph 
    #@end paleocar_predict_model
    #
    #@begin uncertainty_paleocar_model 
    #@in paleocar_interim_model @as paleocar_model.rds 
    #
    #@out image @as uncertainty_graph 
    #@end uncertainty_paleocar_model
    
#@end exec_paleocar 


