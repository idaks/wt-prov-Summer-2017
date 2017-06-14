
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

    # Generate predictions and uncertainty (and plot timeseries of each)
    jpeg(paste0(testDir,'predictions.jpg'))
    predict_paleocar_models(models = recon_vector,
                            #meanVar = "chained",
                            prediction.years = prediction.years) %>%
      plot(x = as.numeric(names(.)),
           y = .,
           type = "l",
           main="Predicted PPT Values Vs Prediction Years",
           xlab="Prediction Years", ylab="Predcited PPT Values")

    dev.off();

    jpeg(paste0(testDir,'uncertainty.jpg'));
    uncertainty_paleocar_models(recon_vector,
                                prediction.years = prediction.years) %>%
      plot(x = as.numeric(names(.)),
           y = .,
           type = "l",
           main="Uncertain PPT Values Vs Prediction Years",
           xlab="Prediction Years", ylab="Uncertain PPT Values")
    dev.off();
    sink()
  }
  if(input_data_type=="m"){
    sink(paste0(testDir,'paleocar_model_log.txt'))
    recon_matrix <- paleocar_models(predictands = predictands,
                                    chronologies = itrdb,
                                    calibration.years = calibration.years,
                                    prediction.years = prediction.years,
                                    verbose = verbose)

    # Generate predictions and uncertainty (and plot location means in uncertainty)
    jpeg(paste0(testDir,'predictions.jpg'));
    predict_paleocar_models(models = recon_matrix,
                            meanVar = "chained",
                            prediction.years = prediction.years) %>%
      rowMeans() %>%
      plot(x = as.numeric(names(.)),
           y = .,
           type = "l",
           main="Predcited PPT Values Vs Prediction Years",
           xlab="Prediction Years", ylab="Predcited PPT Values")

    dev.off()

    jpeg(paste0(testDir,'uncertainty.jpg'));
    uncertainty_paleocar_models(models = recon_matrix,
                                prediction.years = prediction.years) %>%
      rowMeans() %>%
      plot(x = prediction.years,
           y = .,
           type = "l",
           main="Uncertain PPT Values Vs Prediction Years",
           xlab="Prediction Years", ylab="Uncertain PPT Values")

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

    sink()
    ## Plotting and saving the graphs for predictions generated by paleocar model##

    jpeg(paste0(testDir,'predictions.jpg'))
    recon_data$predictions %>%
      raster::mean() %>%
      raster::plot(main="Predcited PPT Values Vs Prediction Years",
                   xlab="Prediction Years", ylab="Predcited PPT Values")
    dev.off();

    ## Plotting and saving the graphs for uncertainty generated by paleocar model##

    jpeg(paste0(testDir,'uncertainty.jpg'))
    recon_data$uncertainty %>%
      raster::mean() %>%
      raster::plot(main="Uncertain PPT Values Vs Prediction Years",
                   xlab="Prediction Years", ylab="Uncertain PPT Values")
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
