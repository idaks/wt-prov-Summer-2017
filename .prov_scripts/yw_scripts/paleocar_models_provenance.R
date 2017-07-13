#@begin paleocar_models 
#@in prism_data  @uri /.output/{session_id}/{run_id}/{data_file}.csv @desc A RasterBrick, RasterStack, matrix, or vector of the numeric predictand (response) variable.
#@in calibration.years  @desc An integer vector of years corresponding to the layers in the \code{predictands} brick.
#@in prediction.years   @desc An optional integer vector of years for the reconstruction.
#@param itrdb @desc A matrix of tree ring chronologies, indexed annually. Each chronology is a column. The first column must be labeled "YEAR" and is the calendar year.
#@param min_width @as min.width @desc An integer, indicating the minimum number of tree-ring samples allowed for that year of a chronology to be valid.
#@param verbose @desc Logical, display status messages during run.
#@out models @uri file:/.output/{session_id}/{run_id}/{label}.model.Rds


#@BEGIN get_predictor_matrix @desc Get chronologies matrix for the calibration years.
#@param tree_ring_data @as itrdb 
#@param calibration.years @as calibration.years
#@param min.width @desc integer, indicating the minimum number of tree-ring samples allowed 
#@OUT predictor.matrix
#@end get_predictor_matrix

#@begin get_max_preds @desc Get the maximum number of predictors.
#@in matrix @as predictor.matrix
#@out max.preds
#@end get_max_preds 
  
#@BEGIN get_reconstruction_matrix @desc Get chronologies matrix for the prediction years.
#@IN chronologies @as itrdb 
#@IN reconstruction.years @as prediction.years
#@PARAM min.width @desc integer, indicating the minimum number of tree-ring samples allowed 
#@OUT reconstruction.matrix
#@END get_reconstruction_matrix

#@begin gen_predictand_matrix @desc Generate a matrix from the input prism data file.
#@in data @as prism_data
#@out predictand.matrix 
#@end gen_predictand_matrix

#@BEGIN get_predlist @desc Get list of stepwise predictors from a reconstruction matrix
#@IN matrix @as reconstruction.matrix
#@OUT predlist
#@END get_predlist

#@BEGIN getCarscores @desc Compute CAR scores over a matrix of predictands. 
#@IN matrix @as predictand.matrix 
#@IN predictor.matrix 
#@OUT carscores

#@end getCarscores

#@BEGIN calculateModels @desc Prepare data and calculate CAR scores
#@IN predlist @as predlist
#@IN carscores @as carscores
#@IN max_preds @as max.preds
#@OUT linear.models     
    
#@end calculateModels

# @BEGIN optimizeModels 
# @IN linear.models
# @OUT final.models @as models @uri file:/.output/{session_id}/{run_id}/{label}.model.Rds 
# @end optimizeModels

                
#@end paleocar_models 