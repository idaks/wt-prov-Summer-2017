'''
@begin execute_plaeocar @desc model for collecting prediction ppt value, using the ITRDB. 
@param 112W36N.nc @desc Netcdf file for extent generation
@in coordinates @desc lat and long values for defining the region of study 

@begin prism_data_generator @desc generating prism data vector for ppt of the region.
@in 112W36N.nc @desc file for getting the extent of the boundary region. 
@in coordinates @desc lat and long values for defining the region of study. 
@out 112W36N.csv @desc file with the prism data values 

'''
prism_data <- function(coordinates,   #Longitude and latitude.
                       in_file_name,  # the NetCDF file format.
                       out_file_name,  # the output file name.
                       ...)
  '''
@end prism_data_generator


@begin run_paleocar @desc executing paleocar for generating the model
@in prism_data  @as 112W36N.csv @desc file with the prism data values @file 112W36N.csv.
@param itrdb @as chronologies @desc The tree ring database for calculating the paleocar model. 
@in calibration_years @as calibration.years
@in prediction_years  @as prediction.years
@in output_dir        @as testDir
@in model_label       @as label        
@in log_output        @as verbose @desc for loggnig output of the execution to file.
@in data_type         @as input_data_type@desc type of Input as vector, matrix or raster object

'''
run_paleocar(  testDir,
               prism_data,
               label,
               chronologies,
               calibration.years=calibration.years,
               prediction.years=prediction.years,
               verbose=verbose,
               input_data_type
)
'''


@out Model_paleocar @desc file with the prism data values@file 112W36N.csv
@out Model_predict_ppt 
@out model_uncertain_ppt
@out recon_vector.model 
@out recon_predict_vector.csv
@out recon_uncertain_vector.csv
@end run_paleocar

@out paleocar_model
@end execute_plaeocar

'''
