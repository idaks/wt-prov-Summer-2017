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


### Complete Recon WF Graphs ## 

sh render_recon_complete_wf_graph.sh main.P | dot -Tpdf -o ../results/recon_wf_main.pdf 

sh render_recon_complete_wf_graph.sh get_itrdb_data.P | dot -Tpdf -o ../results/recon_wf_get_itrdb_data.pdf 

sh render_recon_complete_wf_graph.sh extract_prism_data.P | dot -Tpdf -o ../results/recon_wf_extract_prism_data.pdf 

sh render_recon_complete_wf_graph.sh paleocar_models.P | dot -Tpdf -o ../results/recon_wf_paleocar_models.pdf 

sh render_recon_complete_wf_graph.sh exec_paleocar.P | dot -Tpdf -o ../results/recon_wf_exec_paleocar.pdf 


## Downstream WF graphs ### 

sh render_wf_graph_downstream_of_data_q3.sh main.P prism_data prism_data  | dot -Tpdf -o ../results/recon_wf_ds_main_prism_data.pdf 

sh render_wf_graph_downstream_of_data_q3.sh main.P itrdb itrdb | dot -Tpdf -o ../results/recon_wf_ds_main_itrdb.pdf 

sh render_wf_graph_downstream_of_data_q3.sh main.P prediction_year prediction_year | dot -Tpdf -o ../results/recon_wf_ds_prediction_year.pdf 






