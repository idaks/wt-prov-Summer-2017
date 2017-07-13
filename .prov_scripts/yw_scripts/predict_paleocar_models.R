#@BEGIN predict_paleocar_models @desc generates climate predictions over a specified prediction period
#@PARAM meanvariance 
#@param floor  
#@IN models @uri file:/.output/{session_id}/{run_id}/{label}.models.rds 
#@param ceiling 
#@IN prediction.years 
#@OUT plot @as timeseries_plot_prediction @uri file:/.output/{session_id}/{run_id}/prediction.jpg
#@OUT predictions_model @uri file:/.output/{session_id}/{run_id}/{label}.prediction.rds
#@end predict_paleocar_models