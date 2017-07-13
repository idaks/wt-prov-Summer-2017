
#@begin exec_paleocar
#@in user_input
#@param netcdf_file @file {data_file}.nc @uri file:/data/{data_file}.nc
#@param itrdb @file {data_file}.nc @uri file:/data/itrdb.Rda
#@param calibration_year
#@in web_prediction_input_year


#@out paleocar_models @uri  file:/.output/{session_id}/{run_id}/{label}.models.rds 
#@out prediction_model @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds 
#@out uncertainty_model @uri  file:/.output/{session_id}/{run_id}/{label}.uncertainty.rds
#@out prediction_plot @uri file:/.output/{session_id}/{run_id}/{label}.prediction.jpg
#@out uncertainty_plot @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.jpg

    #@begin get_user_input @desc Get coordinates and years for predicting the model from the web app  user.
    #@in web_app_input @as user_input
    
    #@out coordinates 
    #@out prediction.year
    #@end get_user_input

    #@begin get_prism_data @desc Load netcdf file with ppt data and extract the values for the input coordinates.
    
    #@in coordinates @desc contains latitude and longitude values using the marker location
    #@param spatial_file @as netcdf_file
    
    #@out prism_data @uri file:/.output/{session_id}/{run_id}/{data_file}.csv 
    #@end get_prism_data
    

    #@begin paleocar_model @desc create paleocar model for predicting the climate. 

    #@param itrdb @as itrdb
    #@in predictands  @as prism_data @file 112W36N.csv @desc A RasterBrick, RasterStack, matrix, or vector of the numeric predictand (response) variable.
    #@param cal_year @as calibration_year
    #@in prediction.year  @as prediction.year  @desc An optional integer vector of years for the reconstruction.
    

    #@out paleocar_models @uri  file:/.output/{session_id}{run_id}/{label}.models.rds     
    #@end paleocar_model

    #@begin paleocar_predict_model 
    #@in paleocar_models @uri  file:/.output/{session_id}/{run_id}/{label}.models.rds 
    #@in prediction.year @as prediction.year 
    
    #@out prediction_model @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds
    #@out plot @as prediction_plot  @uri file:/{session_id}/{run_id}/{label}.prediction.jpg 
    #@end paleocar_predict_model


    
    #@begin uncertainty_paleocar_model 
    #@in paleocar_models @uri  rds:/.output/{session_id}/{run_id}/{label}.models.rds
    #                    @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds$predictands
    #@in prediction.year @as prediction.year
    
    #@out model @as uncertainty_model  @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.rds 
    #@out plot @as uncertainty_plot  @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.jpg 
    #@end uncertainty_paleocar_model
    

#@end exec_paleocar 

