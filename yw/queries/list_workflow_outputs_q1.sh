#!/usr/bin/env bash

file=$1
xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN

set_prolog_flag(unknown, fail).

['$RULES_DIR/general_rules.P'].
['$VIEWS_DIR/${file}'].
%-------------------------------------------------------------------------------
banner( 'Q1_Pro',
        'List the workflow outputs',
        'q1(OutputName)').
[user].
:- table q1/1.
q1(OutputName) :-
    yw_workflow_script(WorkflowId,_,_,_),
    yw_step_output(WorkflowId, _, _, _, _,_, OutputName).
end_of_file.
printall(q1(_)).

END_XSB_STDIN