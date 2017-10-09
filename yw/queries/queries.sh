#!/usr/bin/env bash


## list the inputs for the upstream for the 


## list the inputs for the upstream of the prism_data_for_coordinates. 
sh list_inputs_upstream_of_data_q2.sh main.P prism_data_for_coordinates prism_data_for_coordinates


## What are the downstream products for the tree rings used in getting the 
## species of trees.
sh list_outputs_downstream_of_data_q3.sh get_species_of_tree_used.P itrdb itrdb



## What are the outputs for the downstream of the prism_data ?
sh list_outputs_downstream_of_data_q3.sh main.P prism_data prism_data


## What are the outputs for the downstream of the paleocar models used in tree rings ? 

sh list_outputs_downstream_of_data_q3.sh get_tree_ring_values.P paleocar_models paleocar_models


## What are the inputs for the upstreams for the paleocar_models? 

sh list_inputs_upstream_of_data_q2.sh wrapper_paleocar.P paleocar_models paleocar_models


## what are the outputs for the downstream for the label? 

sh list_outputs_downstream_of_data_q3.sh wrapper_paleocar.P label label 


