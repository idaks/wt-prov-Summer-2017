#!/usr/bin/env bash -l
#
# ./run_queries.sh &> run_queries.txt

#source ../settings.sh

 

cd $FACTS_DIR

for file in `ls -a *.P` ;
do
filename=`ls -1 $file | sed -e 's/\..*$//' `

xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN > ../results/${filename}.log

['$FACTS_DIR/${file}'].
['$MODEL_DIR/${file}'].
['$VIEWS_DIR/${file}'].
['$RULES_DIR/general_rules.P'].
['$RULES_DIR/yw_views.P'].
['$RULES_DIR/yw_graph_rules.P'].

set_prolog_flag(unknown, fail).

%-------------------------------------------------------------------------------
 banner( 'EQ1','What are the names N of all program blocks?','eq1(ProgramName)').
[user].
:- table eq1/1. 
eq1(ProgramName) :- 
annotation(_, _, _, 'begin', _, ProgramName).
end_of_file.
printall(eq1(_)).
%-------------------------------------------------------------------------------


%-------------------------------------------------------------------------------


banner( 'EQ2','What out ports are qualified with URIs','eq2(PortName)').
[user].
:- table eq2/1.
eq2(PortName) :- annotation(URI, _, _, 'uri', _, _),annotation(OUT, _, _, 'out', _, PortName), annotation_qualifies(URI, OUT).
end_of_file.
printall(eq2(_)).
%-------------------------------------------------------------------------------


%-------------------------------------------------------------------------------

banner( 'EQ3','What products are produced by ports qualified with URIs ','eq2(PortName)').
[user].
% FACT: port(port_id, port_type, port_name, qualified_port_name, port_annotation_id, data_id).
:- table eq3/3.
eq3(PortName,PortType,DataProduct) :- port(port_id, PortType, PortName, _, _, _), port_uri_template(port_id, DataProduct).
end_of_file.
printall(eq2(_,_,_)).
%-------------------------------------------------------------------------------



%-------------------------------------------------------------------------------

banner( 'YW_Q1',
        'What program blocks provide input to gen_paleocar_model?',
		'yw_q1(ProgramName)').
[user].
:- table yw_q1/1.
[user].
:- table yw_q1/1.
yw_q1(ProgramName) :-
	yw_step_input(_,extract_uncertainty_model,_,_,_,_,DataName),
	yw_step_output(_,ProgramName,_,_,_,_,DataName).
end_of_file.
printall(yw_q1(_)).

%-------------------------------------------------------------------------------	
	
%-------------------------------------------------------------------------------


banner( 'YW_Q2',
        'What workflow steps comprise the top-level workflow?',
        'yw_q2(StepName, Description)').
[user].
:- table yw_q2/2.
yw_q2(StepName, Description) :-
    yw_workflow_script(WorkflowId,_,_,_),
    yw_workflow_step(StepId, StepName, WorkflowId, _, _, _),
    yw_description(Program, StepId, _, Description).
end_of_file.
printall(yw_q2(_,_)).
%-------------------------------------------------------------------------------


%-------------------------------------------------------------------------------
banner( 'YW_Q3',
        'What programs have input ports that receive data user_prediction_years?',
        'yw_q3(ProgramName)').
[user].
:- table yw_q3/1.
yw_q3(ProgramName) :-
    yw_step_input(_,ProgramName,_,_,_,_,user_prediction_years).
end_of_file.
printall(yw_q3(_)).

%-------------------------------------------------------------------------------


%-------------------------------------------------------------------------------

banner( 'YW_Q4','What are the names and descriptions of any outputs of the workflow?','yw_q4(OutputName, Description)').
[user].

:- table yw_q4/2.
yw_q4(OutputName,Description) :-
    yw_workflow_script(WorkflowId,_,_,_), yw_step_output(WorkflowId, _, _, PortId, _,_, OutputName), yw_description(port, PortId, _, Description).
end_of_file.
printall(yw_q4(_,_)).
%-------------------------------------------------------------------------------


END_XSB_STDIN

done
