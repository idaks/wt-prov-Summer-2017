#!/usr/bin/env bash
#

file=$1
ProvidedDataName=$2
PrintProvidedDataName=$3

xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN

['../general_rules.P'].
['../yw_rules.P'].
['../views/${file}'].

set_prolog_flag(unknown, fail).

%-------------------------------------------------------------------------------
banner( 'Q2_Pro',
        'List the script inputs that are upstream of data product $PrintProvidedDataName.',
        'q2_pro(DataProduct, InputDataName)').
[user].
:- table q2_pro/2.
q2_pro(DataProduct, InputDataName):-
    yw_data(D1, _, _, _),
    yw_data(D2, DataProduct, _, _),
    yw_data_downstream(D1, D2),
    yw_workflow(_, W, nil, _, _, _),
    yw_inflow(_, W, D1, InputDataName, _, _).
end_of_file.

printall(q2_pro($ProvidedDataName, _)).

%-------------------------------------------------------------------------------


END_XSB_STDIN