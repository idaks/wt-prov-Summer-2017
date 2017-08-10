
#@begin exec_paleocar
#@in user_map_marker_pos  @desc Coordinates of location for reconstruction of paleoclimate. 
#@in user_prediction_years @desc Prediction years for reconstruction of paleoclimate. 
#@param prism_data @file {data_file}.nc @uri file:/data/{data_file}.nc @desc file containing the precipitation values for the particular region
#@param itrdb @file {data_file}.nc @uri file:/data/itrdb.Rda @desc tree ring chronologies database
#@param calibration_year @desc period for calibrating the information for predicting the climate. 
#@param label @desc a user label for the generated paleocar model of the study region. 




#@out paleocar_models @uri  file:/.output/{session_id}/{run_id}/{label}.models.rds @desc R model of the paleocar reconstruction.
#@out prediction_model @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds   @desc  R model of the paleocar reconstruction of prediction.
#@out uncertainty_model @uri  file:/.output/{session_id}/{run_id}/{label}.uncertainty.rds  @desc R model of the paleocar reconstruction of uncertainties.
#@out prediction_plot @uri file:/.output/{session_id}/{run_id}/{label}.prediction.jpg  @desc timeseries plot of prediction model of the paleocar reconstruction.
#@out uncertainty_plot @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.jpg  @desc timeseries plot of uncertainty model of the paleocar reconstruction.
#@out paleocar_model_log_file  @uri file:/.output/{session_id}{run_id}/paleocar_model_log.txt @desc a log file containing information about the execution of paleocar reconstruction.

    #@begin get_user_input @desc Get coordinates and years for predicting the model from the web app  user.
    #@in coordinates @as user_map_marker_pos @desc Coordinates of location for reconstruction of paleoclimate. 
    #@in prediction_year @as user_prediction_years @desc Prediction years for reconstruction of paleoclimate. 
    
    #@out coordinates  @desc Coordinates of location for reconstruction of paleoclimate. 
    #@out prediction_year @as prediction_years @desc Prediction years for reconstruction of paleoclimate. 
    #@out session_id
    #@out run_id 
    #@end get_user_input 

    #@begin extract_prism_data @desc Load the prism data file with precipitation values and extract the data for the input coordinates and save as a csv file.
    #@in session_id
    #@in run_id 
    #@in coordinates @desc Coordinates of location for reconstruction of paleoclimate. 
    #@param spatial_file @as prism_data @desc file containing the precipitation values for the particular region.
    
    #@out prism_data_for_coordinates @uri file:/.output/{session_id}/{run_id}/{data_file}.csv @desc file containing the precipitation values for the selected region.
    #@end extract_prism_data
    
    #@begin gen_paleocar_model @desc generate paleocar models for predicting the climate for the given years. 
    #@param label @desc user entered label for the study region. 
    #@param cal_year @as calibration_year @desc period for calibrating the information for predicting the climate. 
    #@param itrdb @as itrdb @desc tree ring chronologies database 
    #@in prediction_year  @as prediction_years  @desc An optional integer vector of years for the reconstruction.
    #@in predictands  @as prism_data_for_coordinates @file 112W36N.csv @desc A RasterBrick, RasterStack, matrix, or vector of the numeric predictand (response) variable.

    #@out paleocar_models @uri  file:/.output/{session_id}{run_id}/{label}.models.rds @desc  R model of the paleocar reconstruction of prediction.
    #@out log_file @as paleocar_model_log_file @uri file:/.output/{session_id}{run_id}/paleocar_model_log.txt   @desc a log file containing information about the execution of paleocar reconstruction.
    #@end gen_paleocar_model


    #@begin extract_prediction_model @desc extract the rasterbrick reconstruction from a PaleoCAR batch model for the specified prediction period.
    #@in paleocar_models @uri  file:/.output/{session_id}/{run_id}/{label}.models.rds  @desc R model of the paleocar reconstruction.
    #@in prediction.year @as prediction_years @desc Prediction years for reconstruction of paleoclimate. 
    
    #@out prediction_model @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds @desc  R model of the paleocar reconstruction of prediction.
    #@out plot @as prediction_plot  @uri file:/{session_id}/{run_id}/{label}.prediction.jpg  @desc timeseries plot of prediction model of the paleocar reconstruction.
    #@end gen_prediction_model


    #@begin extract_uncertainty_model @desc extract the LOOCV uncertainty information from the set of Paleocar models for specified period.
    #@in paleocar_models @uri  rds:/.output/{session_id}/{run_id}/{label}.models.rds  @desc R model of the paleocar reconstruction.
    #                    @uri  file:/.output/{session_id}/{run_id}/{label}.prediction.rds$predictands @desc R model of the paleocar reconstruction.
    #@in prediction.year @as prediction_years @desc Prediction years for reconstruction of paleoclimate. 
    
    #@out model @as uncertainty_model  @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.rds  @desc R model of the paleocar reconstruction of uncertainties.
    #@out plot @as uncertainty_plot  @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.jpg  @desc timeseries plot of uncertainty model of the paleocar reconstruction.
    #@end gen_uncertainty_model

#@end exec_paleocar 

