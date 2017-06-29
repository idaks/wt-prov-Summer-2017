

    #@begin paleocar_models
    #@in chronologies @as itrdb @desc A matrix of tree ring chronologies, indexed annually. Each chronology is a column. The first column must be labeled "YEAR" and is the calendar year.
    #@in predictands  @as prism_data @file 112W36N.csv @desc A RasterBrick, RasterStack, matrix, or vector of the numeric predictand (response) variable.
    #@in calibration.years @as calibration_year @desc An integer vector of years corresponding to the layers in the \code{predictands} brick.
    #@in prediction.years  @as prediction_year  @desc An optional integer vector of years for the reconstruction.
    #@param min_width @as min.width @desc An integer, indicating the minimum number of tree-ring samples allowed for that year of a chronology to be valid.
    #@param verbose @desc Logical, display status messages during run.


    paleocar_models <- function(chronologies,
                            predictands,
                            calibration.years,
                            prediction.years = NULL,
                            min.width = NULL,
                            verbose = F,
                            ...)


    
      #@BEGIN get_predictor_matrix
      #@IN chronologies @as itrdb
      #@IN calibration.years @as calibration_year
      #@PARAM min.width
      #@OUT predictor.matrix
      #@OUT max.preds
       
 
      predictor.matrix <- get_predictor_matrix(chronologies = chronologies,
                                               calibration.years = calibration.years,
                                               min.width = min.width)
                                            
     #@END get_predictor_matrix

          #@BEGIN get_reconstruction_matrix
          #@IN chronologies @as itrdb 
          #@IN reconstruction.years @as prediction_year
          #@PARAM min.width
          #@OUT reconstruction.matrix

            reconstruction.matrix <- get_reconstruction_matrix(chronologies=chronologies, reconstruction.years=prediction.years, min.width=min.width)
            reconstruction.matrix <- reconstruction.matrix[,colnames(predictor.matrix)]
          #@END get_reconstruction_matrix
    
          #@BEGIN get_predlist
          #@IN reconstruction.matrix
          #@OUT predlist
          
          predlist <- get_predlist(reconstruction.matrix)
          
			#@END get_predlist
            #
            #@begin get_predictand_matrix 
            #@in predictands @as prism_data
            #@out predictand.matrix 
            #@end get_predictand_matrix 
            #
            #@BEGIN getCarscores
            #@IN predictand.matrix
            #@IN predictor.matrix
            #@OUT carscores
                carscores <- carscore_batch(predictand.matrix=predictand.matrix, predictor.matrix=predictor.matrix)
                carscores.ranks <- matrixStats::colRanks(1-(carscores^2), preserveShape=T)
                rownames(carscores.ranks) <- rownames(carscores)
                colnames(carscores.ranks) <- colnames(carscores)
                carscores <- carscores.ranks
                rm(carscores.ranks); gc(); gc()
                carscores <- data.table::data.table(t(carscores))

            #@END getCarscores
              
                #@BEGIN calculateModels
                #@IN predlist
                #@IN carscores
                #@IN max.preds
                #@OUT linear.models

                
                  allModels <- data.table::data.table(cell=numeric(),year=numeric(),model=numeric(),numPreds=numeric(),CV=numeric(),AICc=numeric(),coefs=numeric())
                  complete.cell.years <- data.table::data.table(cell=numeric(),year=numeric())
                  times <- vector('numeric',max(prednums))
                
                #@end calculateModels
                #@BEGIN defineLinearModels
                #@IN predlist @as predlist
                #@IN carscores @as carscores
                #@OUT models @as models 
                #@OUT matches @as matches 
                

                #@END defineLinearModels 

                    #@BEGIN calculateLinearModels
                    #@IN models
                    #@IN matches
                    #@OUT coefficients
                    #@OUT model.errors
                    
                    #@end calculateLinearModels
                    
                        #@BEGIN simplifyLinearModels
                        #@IN coefficients
                        #@IN model.errors
                        #@OUT final.models
                    
                        #@END simplifyLinearModels
           #@BEGIN optimizeModels
           #@IN linear.models
           #@OUT final.models
           
           #@END optimizeModels
    #@OUT final.models
    #@end paleocar_models

