#@begin extract_uncertainty_model @desc extract the LOOCV uncertainty information from the set of Paleocar models for specified period.
#@IN models @uri file:/.output/{session_id}/{run_id}/{label}.models.rds
#@IN prediction_years  

#@OUT plot @as timeseries_plot_uncertainty @uri file:/.output/{session_id}/{run_id}/uncertainty.jpg
#@OUT uncertainty_model @uri file:/.output/{session_id}/{run_id}/{label}.uncertainty.rds 

#@end uncertainty_paleocar_models