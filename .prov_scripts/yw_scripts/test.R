# @BEGIN calculate_Models 
# @IN predlist
# @IN carscores
# @IN max.preds
# @OUT linear.models

# @BEGIN defineLinearModels
# @IN predlist
# @IN carscores
# @OUT models
# @OUT matches

#@begin test1 
#@in carscores 
#@end test1

#@begin test2
#@in predlist 
#@end test2

# @END defineLinearModels


if(verbose) cat("\nDefine models:", round(difftime(Sys.time(),new.t,units='mins'),digits=2),"minutes")
# @BEGIN calculateLinearModels
# @IN models
# @IN matches
# @OUT coefficients
# @OUT model.errors
# @END calculateLinearModels

# @BEGIN simplifyLinearModels
# @IN coefficients
# @IN model.errors
# @OUT final.models
## LMS SIMPLIFY PREP
new.t <- Sys.time()
# @END simplifyLinearModels

# @END calculateModels
