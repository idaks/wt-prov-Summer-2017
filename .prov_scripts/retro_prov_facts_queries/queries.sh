#!/usr/bin/env bash -l
#
# ./run_queries.sh &> run_queries.txt

#source $SCRIPT_SETTINGS_FILE

dir="/d/Study/Internship/WT_PaleoCar_2017/meteor_example/wt-prov-summer-2017/.Prov_Scripts/facts/"

cd $dir

for file in `ls -a *.P` ;
do
xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN > ../results/${file:0:${#file}-2}.log

['../facts/${file}'].
['../models/${file}'].
['../views/${file}'].
['../retro_prov_facts_queries/general_rules.P'].
['../retro_prov_facts_queries/yw_views.P'].


set_prolog_flag(unknown, fail).

%-------------------------------------------------------------------------------
 banner( 'EQ2','What are the names N of all program blocks?','eq2(ProgramName)').
[user].
:- table eq2/1. eq2(ProgramName) :- annotation(_, _, _, 'begin', _, ProgramName).
end_of_file.
printall(eq2(_)).
%-------------------------------------------------------------------------------


%-------------------------------------------------------------------------------


banner( 'EQ3','What out ports are qualified with URIs','eq3(PortName)').
[user].
:- table eq3/1.
eq3(PortName) :- annotation(URI, _, _, 'uri', _, _),annotation(OUT, _, _, 'out', _, PortName), annotation_qualifies(URI, OUT).
end_of_file.
printall(eq3(_)).
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

banner( 'YW_Q4','What are the names and descriptions of any outputs of the workflow?','yw_q4(OutputName, Description)').
[user].

:- table yw_q4/2.
yw_q4(OutputName,Description) :-
    yw_workflow_script(WorkflowId,_,_,_), yw_step_output(WorkflowId, _, _, PortId, _,_, OutputName), yw_description(port, PortId, _, Description).
end_of_file.
printall(yw_q4(_,_)).
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------


banner( 'YW_Q6',
        'What are the output data for the paleocar?',
        'yw_q6(DataName)').
[user].
:- table yw_q6/1.
yw_q6(DataName) :-
         yw_outflow(_,_,_,DataName,_,exec_paleocar,_,_).
end_of_file.
printall(yw_q6(_)).
%-------------------------------------------------------------------------------


%-------------------------------------------------------------------------------


banner( 'YW_Q7',
        'What are the input data for the generation of the prediction plot in paleocar?',
        'yw_q7(DataName,StepName)').
[user].
:- table yw_q7/2.
yw_q7(DataName,StepName) :-
			yw_outflow(_,StepName,_,_,_,_,_,uncertainty_plot), 
			yw_flow(_, SourceProgramName, _, _, _,_, _, _, _, StepName),
			yw_inflow(_,_,_,DataName,_,SourceProgramName).
end_of_file.
printall(yw_q7(_,_)).
%-------------------------------------------------------------------------------


END_XSB_STDIN

done
