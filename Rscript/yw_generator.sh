#/usr/bin/bash

# put Git for Windows at beginning of PATH
export PATH='/c/Program Files/Git/bin':$PATH

# put MSYS2 executables before Git for Windows so that MSYS2 bash and sh are used 
export PATH=/mingw64/bin:/usr/local/bin:/usr/bin:/bin:$PATH 

# configure Java
export JAVA_HOME='/c/Program Files/Java/jdk1.7.0_80'
export PATH=$PATH:$JAVA_HOME/bin

# configure GraphViz
export GRAPHVIZ_HOME='/c/Program Files (x86)/Graphviz2.38/' 
export PATH=$PATH:$GRAPHVIZ_HOME/bin

# configure XSB 
export XSB_HOME='/c/Program Files (x86)/XSB' 
export PATH=$PATH:$XSB_HOME/config/x64-pc-windows/bin 

alias yw="java -jar /d/Study/Internship/WT_PaleoCar_2017/YesWorkflow/yesworkflow-0.2.1.1-jar-with-dependencies.jar"
 

script_dir="/d/Study/Internship/WT_PaleoCar_2017/meteor_example/wt-prov-summer-2017/Rscript"
yw_dir="/d/Study/Internship/WT_PaleoCar_2017/meteor_example/wt-prov-summer-2017/yw"

#@begin yw_artifacts @desc YW artifacts creating script using YW annotations.

#@in script_dir
#@param yw.properties
#@param yw_graph_rules.P
#@param gv_rules.P
#@param general_rules.P
#@param yw_rules.P
#@param yw_views.P
#@param yw_views.sh 
#@param yw_queries.sh
#@param yw_jar_file @file yesworkflow-0.2.1.1-jar-with-dependencies.jar

cd $script_dir
#mkdir -p prov_pdf svg_files gv_files graphs recon results models views facts

cd $yw_dir
rm -rf prov_pdf/* svg_files/* gv_files/* graphs/* 

#@begin get_filenames @desc get the filenames from the scripts directory.
#@in script_dir 

#@out filename 
#@end get_filenames 

#@begin gen_dot_files @desc generate yeskworkflow graph files. 
#@in filename
#@param yw_jar_file
#@param yw.properties

#@out gv_files @uri file:gv_files/{filename}.gv
#@end gen_yw_files

#@begin gen_png_files @desc generate png files from doT files
#@in gv_files
#@param yw.properties
#@param yw_jar_file
#@out graphs @uri file:graphs/{filename}.png
#@end  gen_png_files 

#@begin gen_pdf_files  @desc generate pdf files from doT files 
#@in gv_files
#@param yw_jar_file
#@param yw.properties 
#@out prov_pdf @uri file:prov_pdf/{filename}.pdf
#@end  gen_pdf_files 

#@begin gen_svg_files  @desc generate svg files from doT files
#@in gv_files
#@param yw_jar_file
#@param yw.properties
#@out svg_files @uri file:svg_files/{filename}.svg
#@end  gen_svg_files

#@begin extract_graph_facts @desc extract datalog facts from the graphs
#@param yw.properties
#@param yw_jar_file
#@in filename 

#@out facts @uri file:facts/{filename}.P
#@end extract_graph_facts

#@begin extract_model_facts @desc extract datalog facts from the model. 
#@in filename 
#@param yw_jar_file
#@param yw.properties
#@out models @uri file:models/{filename}.P
#@end extract_model_facts



cd $script_dir

for file in `ls -1 *.R  *.java  *.sh` ;
do

 filename=`ls -1 $file | sed -e 's/\..*$//' `
 yw graph $file > $yw_dir/gv_files/${filename}.gv
 yw graph $file | dot -Tpdf -o $yw_dir/prov_pdf/${filename}.pdf
 yw graph $file | dot -Tpng -o $yw_dir/graphs/${filename}.png
 yw graph $file | dot -Tsvg -o $yw_dir/svg_files/${filename}.svg

 yw extract -c extract.factsfile $file > $yw_dir/facts/${filename}.P
 yw model   -c model.factsfile   $file > $yw_dir/models/${filename}.P
 
done

cd $yw_dir


#@begin gen_views @desc create datalog facts views from the models files.
#@in filename
#@in models
#@in facts

#@param general_rules.P
#@param yw_views.P
#@param yw_graph_rules.P
#@param yw_jar_file

#@out views @uri file:views/{filename}.P
#@end gen_views

# genereate the views and execute YW queries for the model. 
sh yw_views.sh 


#@begin exec_queries @desc execute prospective provenance queries.
#@in filename
#@in models
#@in facts
#@in views

#@param general_rules.P
#@param yw_views.P
#@param yw_graph_rules.P
#@param yw_jar_file

#@out results @uri file:results/{filename}.log
#@end exec_queries


sh yw_queries.sh 




## Execute the YW recon for the model

#@begin exec_yw_recon @desc execute yw recon for the run
#@in filename
#@param yw.properties 
#@param yw_jar_file

#@out recon @uri file:recon/{filename}.P
#@end exec_yw_recon

cd $script_dir

for file in `ls -1 *.R  *.java *.sh` ;
do
 filename=`ls -1 $file | sed -e 's/\..*$//' `
 sed -i -e 's|#extract.sources     = ../Rscript/file|'"extract.sources     = ../Rscript/${file}"'|g' yw.properties 
 sed -i -e 's|#recon.factsfile     = ../yw/recon/file|'"recon.factsfile     = ../yw/recon/${filename}.P"'|g' yw.properties 
 yw recon
 sed -i -e 's|'"extract.sources     = ../Rscript/${file}"'|#extract.sources     = ../Rscript/file|g' yw.properties 
 sed -i -e 's|'"recon.factsfile     = ../yw/recon/${filename}.P"'|#recon.factsfile     = ../yw/recon/file|g' yw.properties 
done

#@out graphs
#@out models
#@out facts
#@out results
#@out recon 
#@out svg_files
#@out prov_pdf
#@out views
#@out gv_files
#@end yw_artifacts

