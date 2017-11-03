#!/usr/bin/env bash
#
file=$1
ProvidedDataName=$2
PrintProvidedDataName=$3

xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN

['$RULES_DIR/general_rules.P'].
['$RULES_DIR/yw_rules.P'].
['$VIEWS_DIR/${file}'].

set_prolog_flag(unknown, fail).

%-------------------------------------------------------------------------------
banner( 'Q3_Pro',
        'List the outputs that depend on $PrintProvidedDataName.',
        'q3_pro(UpstreamDataName, OutputDataName)').
[user].
:- table q3_pro/2.
q3_pro(UpstreamDataName, OutputDataName):-
    yw_data(D1, UpstreamDataName, _, _),
    yw_data(D2, _, _, _),
    yw_data_downstream(D1, D2),
    yw_workflow(_, W, nil, _, _, _),
    yw_outflow(_, _, D2, OutputDataName, _, W, _, _).
end_of_file.

printall(q3_pro($ProvidedDataName, _)).
%-------------------------------------------------------------------------------

END_XSB_STDIN
