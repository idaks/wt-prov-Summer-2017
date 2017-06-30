
# For testing th script if you want see commands on server terminal
# set techo=True
options(echo=FALSE)

## this option is used for taking the inputs from command line.

args <- commandArgs(trailingOnly = TRUE)

## Print the args for testing if needed.

# print(args)


## load the librariers.
library(paleocar)
library(magrittr)
library(raster)
library(magrittr)
library(tibble)
library(readr)
library(wrapperpaleocar)

## Create wrapper functions


############################################################
## Function for creating the Prism data,                   #
## using the NetCDF file, location coordinates.            #
## The output is a csv file                                #
############################################################

prism_data <- function(coordinates,   #Longitude and latitude.
                       in_file_name,  # the NetCDF file format.
                       out_file_name,  # the output file name.
                       ...){

  # as of now using only 112W36N.nc4 file,
  # later the parameter can be passed directly.

  in_file_name=in_file_name
  out_file_name= out_file_name
  # load the netcdf file
  raster::brick(in_file_name) %>%
    # extract the point
    raster::extract(coordinates) %>%

    # Transpose to columnar form for PaleoCAR processing
    t() %>%

    # Convert to tibble
    tibble::as_tibble() %>%

    # Save the data as a csv or NetCDF file which can be used later in the paleocar wrapper.
    readr::write_csv(out_file_name) #%>%
  #devtools::use_data(out_file_name, overwrite = TRUE)
}


####################################################################
## Function for executing the Paleocar Models                     ##
## Input parameters:                                              ##
## chronologies, prediction, calibration, prism data of           ##
## region, label, and test directory for saving output file       ##
## Output:                                                        ##
## Generates the plots for prediciton and uncertainty,            ##
## logs the execution output into the paleocar_model_log.txt file ##
####################################################################

run_paleocar <- function (testDir,
                          prism_data,
                          label,
                          itrdb,
                          calibration.years,
                          prediction.years,
                          verbose,
                          input_data_type,
                          ...){
  ## Create the test directory in which the plots whould be generated
  unlink(testDir)
  dir.create(testDir, showWarnings=F, recursive=T)
  
  out_file_name<- 'outputfile.csv'
  predictands <- prism_data
  chronologies <- itrdb
  calibration.years <- calibration.years
  prediction.years <- prediction.years
  verbose = T

  ## log the hisotry of execution into  a file



  if(input_data_type=="v"){
    sink(paste0(testDir,'paleocar_model_log.txt'))
    recon_vector <- paleocar_models(predictands = predictands,
                                    chronologies = itrdb,
                                    calibration.years = calibration.years,
                                    prediction.years = prediction.years,
                                    verbose = verbose)
    
    
    ## Save the output of the paleocar model 
    ## it contains a list as ouput and hasa CAR values, AIC's Coeffecients etc.  
    readr::write_rds(recon_vector,
                     path = paste0(testDir,label,".model.Rds"),
                     compress = "gz")

    # Generate predictions and uncertainty (and plot timeseries of each)
    
    recon_predict <-predict_paleocar_models(models = recon_vector,
                            #meanVar = "chained",
                            prediction.years = prediction.years)  
    readr::write_rds(recon_predict,
                     path = paste0(testDir,label,".prediction.Rds"),
                     compress = "gz")
    
    jpeg(paste0(testDir,'predictions.jpg'))
    
    plot(x = as.numeric(names(recon_predict)),
           y = recon_predict,
           type = "l",
           main="Predicted PPT Values Vs Prediction Years",
           xlab="Prediction Years", ylab="Mean PPT Values")
    
    dev.off();

    #Save the output of prediction into a csv file. 
    data.frame(x = as.numeric(names(recon_predict)),y = recon_predict)%>%
      readr::write_csv(paste0(testDir,"/recon_vector_predict.csv"))
    
    
    ## Generating Uncertainty in the model 
    recon_uncertain <- uncertainty_paleocar_models(recon_vector,
                                prediction.years = prediction.years) 
    
    readr::write_rds(recon_uncertain,
                     path = paste0(testDir,label,".uncertainty.Rds"),
                     compress = "gz")

    #save the ouput of the graph as jpeg image. 

    jpeg(paste0(testDir,'uncertainty.jpg'));

      plot(x = as.numeric(names(recon_uncertain)),
           y = recon_uncertain,
           type = "l",
           main="Uncertain PPT Values Vs Prediction Years",
           xlab="Prediction Years", ylab="Mean PPT Values")
    dev.off();
    
    #Save the output of uncertainty into a csv file.
    data.frame(x = as.numeric(names(recon_uncertain)),y = recon_uncertain)%>%
      readr::write_csv(paste0(testDir,"/recon_vector_uncertain.csv"))
    
    sink()
  }
  if(input_data_type=="m"){
    sink(paste0(testDir,'paleocar_model_log.txt'))
    recon_matrix <- paleocar_models(predictands = predictands,
                                    chronologies = itrdb,
                                    calibration.years = calibration.years,
                                    prediction.years = prediction.years,
                                    verbose = verbose)

    ## Save the output of the paleocar model 
    ## it contains a list as ouput and hasa CAR values, AIC's Coeffecients etc.  
    readr::write_rds(recon_matrix,
                     path = paste0(testDir,label,".model_matrix.Rds"),
                     compress = "gz")
    
    # Generate predictions of the model 
    
    recon_pred_matrix <- predict_paleocar_models(models = recon_matrix,
                            meanVar = "chained",
                            prediction.years = prediction.years) 
    

    data.frame(x = as.numeric(names(rowMeans(recon_pred_matrix))),y = rowMeans(recon_pred_matrix))%>%
      readr::write_csv(paste0(testDir,"/recon_matrix_uncertain.csv"))
    
    # Save the graph of the mean predicted values. 

    jpeg(paste0(testDir,'predictions.jpg'));
      
      rowMeans(recon_pred_matrix) %>%
      plot(x = as.numeric(names(.)),
           y = .,
           type = "l",
           main="Predcited PPT Values Vs Prediction Years",
           xlab="Prediction Years", ylab="Mean PPT Values")

    dev.off()

    jpeg(paste0(testDir,'uncertainty.jpg'));
    
    uncertainty_paleocar_models(models = recon_matrix,
                                prediction.years = prediction.years) %>%
      rowMeans() %>%
      plot(x = prediction.years,
           y = .,
           type = "l",
           main="Uncertain PPT Values Vs Prediction Years",
           xlab="Prediction Years", ylab="Mean PPT Values")

    dev.off();
    sink();
  }
  if(input_data_type=="r"){
    sink(paste0(testDir,'paleocar_model_log.txt'))
    ## Executing PaleoCar Model for the dataset ##
    recon_data <-    paleocar( predictands = predictands,
                               label = label,
                               chronologies = chronologies,
                               calibration.years = calibration.years,
                               prediction.years = prediction.years,
                               out.dir = testDir,
                               meanVar = "none",
                               floor = 0,
                               ceiling = NULL,
                               force.redo = T,
                               verbose = verbose)
    
    ## Save the output of the paleocar model 
    ## it contains a list as ouput and hasa CAR values, AIC's Coeffecients etc.  
    readr::write_rds(recon_data,
                     path = paste0(testDir,label,".model_raster.Rds"),
                     compress = "gz")
    sink()
    ## Plotting and saving the graphs for predictions generated by paleocar model##

    jpeg(paste0(testDir,'predictions.jpg'))
    recon_data$predictions %>%
      raster::mean() %>%
      raster::plot(main="Predcited PPT Values Vs Prediction Years",
                   xlab="Prediction Years", ylab="Mean PPT Values")
    dev.off();

    ## Plotting and saving the graphs for uncertainty generated by paleocar model##

    jpeg(paste0(testDir,'uncertainty.jpg'))
    recon_data$uncertainty %>%
      raster::mean() %>%
      raster::plot(main="Uncertain PPT Values Vs Prediction Years",
                   xlab="Prediction Years", ylab="Mean PPT Values")
    dev.off ();
    sink();
  }
}

############################################################
## Function for creating the boundary for the prism data,  #
############################################################

reg_boundary <- function(in_file_name,
                         ... ){
  in_file_name= in_file_name
  x<-raster::brick(in_file_name)
  y<-raster::extent(x)
  y<-as.vector(y)
  return(cat(trimws(y[1:4])))
}
