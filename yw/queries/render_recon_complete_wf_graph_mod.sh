#!/usr/bin/env bash

file=$1 
#session_id=$2
 
xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN
 

['$VIEWS_DIR/${file}'].
['$RECON_DIR/${file}'].
['$MODEL_DIR/${file}'].
['$RULES_DIR/yw_rules.P'].
['$RULES_DIR/gv_rules.P'].
['$RULES_DIR/yw_graph_rules.P'].
['$RULES_DIR/recon_rules.P'].

[user].

:- table Uri_template_label/2.	 
Uri_template_label(Y,Z) :-
	port(X, _, _, _, _,Y),
	port_uri_template(X, Z).
	 
graph :-

    yw_workflow_script(W, WorkflowName, _, _),

    gv_graph('yw_data_view', WorkflowName, 'TB'),

        gv_cluster('workflow', 'black'),
            gv_nodestyle__atomic_step,
            gv_nodes__atomic_steps(W),
            gv_nodestyle__subworkflow,
            gv_nodes__subworkflows(W),
            gv_nodestyle__data_value,
			gv_nodes__input_recon_data_wo_uri(WorkflowId),
			gv_nodestyle__data_value,
            gv_nodes__input_recon_data(W),
            gv_node_style__data,
			gv_nodes__recon_input_output_data_wo_uri(W),
			gv_node_style__data,
            gv_nodes__recon_input_output_data(W),
            gv_nodestyle__data_value,
            gv_nodes__output_recon_data(W),
            gv_node_style__param,
            gv_nodes__params(W),
        gv_cluster_end,

        gv_cluster('inflows', 'white'),
            gv_node_style__workflow_port,
            gv_nodes__inflows(W),
        gv_cluster_end,

        gv_cluster('outflows', 'white'),
            gv_node_style__workflow_port,
            gv_nodes__outflows(W),
        gv_cluster_end,

        gv_edges__data_to_step(W),
        gv_edges__step_to_data(W),
        gv_edges__inflow_to_data(W),
        gv_edges__data_to_outflow(W),

    gv_graph_end.

end_of_file.

graph.

END_XSB_STDIN