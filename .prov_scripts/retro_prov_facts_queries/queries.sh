#!/usr/bin/env bash -l
#
# ./run_queries.sh &> run_queries.txt

#source $SCRIPT_SETTINGS_FILE

dir="/d/Study/Internship/WT_PaleoCar_2017/meteor_example/wt-prov-summer-2017/.Prov_Scripts/facts/"

cd $dir

for file in `ls -a *.P` ;
do
xsb --quietload --noprompt --nofeedback --nobanner << END_XSB_STDIN > ../results/${file}

['../facts/${file}'].
['../models/${file}'].
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

END_XSB_STDIN

done
