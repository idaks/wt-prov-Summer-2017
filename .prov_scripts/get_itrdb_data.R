
#@begin get_itrdb_data
#@in calibration.years
#@in prediction.years
#@in tree.buffer
#@in prism_data 

    #@begin get_treepolygon
    #@in prism_data  
    #@in width @as tree.buffer
    #@out treepolygon 
    #@end get_treepolygon

    #@begin get_itrdb
    #@in recon.years @as prediction.years
    #@in calib.yearr @as calibration.years
    #@in template @as treepolygon 
    #@param label 
    #@param measurement.type 
    #@param chronology.type 
    
    
    #@out itrdb 
    #@end get_itrdb 
    
#@out itrdb 
#@end get_itrdb_data