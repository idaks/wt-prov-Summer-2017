
#@begin exec_paleocar
#@in user_map_marker_pos 
#@in user_prediction_year
#@param prism_data @file {data_file}.nc @uri file:/data/{data_file}.nc
#@param itrdb @file {data_file}.nc @uri file:/data/itrdb.Rda
#@param calibration_year
#@in web_prediction_input_year



#@out paleocar_models @uri  file:/.output/{session_id}/{run_id}/{label}.models.rds 
#@out prediction_model @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds 
#@out uncertainty_model @uri  file:/.output/{session_id}/{run_id}/{label}.uncertainty.rds
#@out prediction_plot @uri file:/.output/{session_id}/{run_id}/{label}.prediction.jpg
#@out uncertainty_plot @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.jpg
#@out paleocar_model_log_file  @uri file:/.output/{session_id}{run_id}/paleocar_model_log.txt 

    #@begin get_user_input @desc Get coordinates and years for predicting the model from the web app  user.
    #@in web_app_input @as user_map_marker_pos
    #@in prediction_year @as user_prediction_year
    
    #@out coordinates 
    #@out prediction_year @as prediction.year
    #@end get_user_input

    #@begin extract_prism_data @desc Load the prism data file with precipitation values and extract the data for the input coordinates and save as a csv file.
    
    #@in coordinates @desc contains latitude and longitude values using the marker location
    #@param spatial_file @as prism_data
    
    #@out prism_data_for_coordinates @uri file:/.output/{session_id}/{run_id}/{data_file}.csv 
    #@end get_prism_data
    
    #@begin gen_paleocar_model @desc generate paleocar models for predicting the climate for the given years. 
    #@param cal_year @as calibration_year
    #@param itrdb @as itrdb
    #@in prediction_year  @as prediction_year  @desc An optional integer vector of years for the reconstruction.
    #@in predictands  @as prism_data_for_coordinates @file 112W36N.csv @desc A RasterBrick, RasterStack, matrix, or vector of the numeric predictand (response) variable.

    #@out paleocar_models @uri  file:/.output/{session_id}{run_id}/{label}.models.rds
    #@out log_file @as paleocar_model_log_file @uri file:/.output/{session_id}{run_id}/paleocar_model_log.txt 
    #@end gen_paleocar_model


    #@begin exrtact_prediction_model @desc extract the rasterbrick reconstruction from a PaleoCAR batch model for the specified prediction period.
    #@in paleocar_models @uri  file:/.output/{session_id}/{run_id}/{label}.models.rds 
    #@in prediction.year @as prediction.year 
    
    #@out prediction_model @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds
    #@out plot @as prediction_plot  @uri file:/{session_id}/{run_id}/{label}.prediction.jpg 
    #@end gen_prediction_model


    #@begin extract_uncertainty_model @desc extract the LOOCV uncertainty information from the set of Paleocar models for specified period.
    #@in paleocar_models @uri  rds:/.output/{session_id}/{run_id}/{label}.models.rds
    #                    @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds$predictands
    #@in prediction.year @as prediction.year
    
    #@out model @as uncertainty_model  @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.rds 
    #@out plot @as uncertainty_plot  @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.jpg 
    #@end gen_uncertainty_model

#@end exec_paleocar 

