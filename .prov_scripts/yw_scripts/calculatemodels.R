#@BEGIN calculateModels
#@IN predlist
#@IN carscores
#@IN max.preds
#@OUT linear.models 
    
    # @BEGIN defineLinearModels
    # @IN predlist @as predlist
    # @IN carscores @as carscores
    # @In maxpreds @as max.preds
    # @OUT models  
    # @OUT matches
    # @end defineLinearModels 
    
    # @BEGIN calculateLinearModels
    # @IN models @as models
    # @IN matches @as matches
    # @OUT coefficients 
    # @OUT model.errors 
    # @end calculateLinearModels
    
    # @BEGIN simplifyLinearModels
    # @IN coefficients 
    # @IN model.errors 
    # @OUT final.models @as linear.models
    # @end simplifyLinearModels

#@end calculateModels
