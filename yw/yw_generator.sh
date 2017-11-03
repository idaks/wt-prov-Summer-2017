#/usr/bin/bash
#
#


source ./settings.sh

 
#@begin yw_artifacts @desc YW artifacts creating script using YW annotations.

#@in dir
#@param yw.properties
#@param yw_graph_rules.P
#@param gv_rules.P
#@param general_rules.P
#@param yw_rules.P
#@param yw_views.P
#@param yw_views.sh 
#@param yw_queries.sh
#@param yw_jar_file @file yesworkflow-0.2.1.1-jar-with-dependencies.jar


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



cd $SCRIPT_DIR

for file in `ls -1 *.R  *.java  *.sh` ;
do

 filename=`ls -1 $file | sed -e 's/\..*$//' `
 $YW_CMD graph $file > $GRAPH_DOT_DIR/${filename}.gv
 $YW_CMD graph $file | dot -Tpdf -o $GRAPH_PDF_DIR/${filename}.pdf
 $YW_CMD graph $file | dot -Tpng -o $GRAPH_PNG_DIR/${filename}.png
 $YW_CMD graph $file | dot -Tsvg -o $GRAPH_SVG_DIR/${filename}.svg

 $YW_CMD extract -c extract.factsfile $file > $FACTS_DIR/${filename}.P
 $YW_CMD model   -c model.factsfile   $file > $MODEL_DIR/${filename}.P
 
done
 

#@begin gen_views @desc create datalog facts views from the models files.
#@in filename
#@in models
#@in facts

#@param general_rules.P
#@param yw_views.P
#@param yw_graph_rules.P
#@param yw_jar_file


cd $RULES_DIR
# genereate the views and execute YW queries for the model. 
sh yw_views.sh 
#@out views @uri file:views/{filename}.P
#@end gen_views


## Execute the YW recon for the model

#@begin exec_yw_recon @desc execute yw recon for the run
#@in filename
#@param yw.properties 
#@param yw_jar_file

#@out recon @uri file:recon/{filename}.P

cd $SCRIPT_DIR

for file in `ls -1 *.R  *.java *.sh` ;
do
 filename=`ls -1 $file | sed -e 's/\..*$//' `
 sed -i -e 's|#extract.sources     = ../Rscript/file|'"extract.sources     = ../Rscript/${file}"'|g' yw.properties 
 sed -i -e 's|#recon.factsfile     = ../yw/recon/file|'"recon.factsfile     = ../yw/recon/${filename}.P"'|g' yw.properties 
 $YW_CMD recon
 sed -i -e 's|'"extract.sources     = ../Rscript/${file}"'|#extract.sources     = ../Rscript/file|g' yw.properties 
 sed -i -e 's|'"recon.factsfile     = ../yw/recon/${filename}.P"'|#recon.factsfile     = ../yw/recon/file|g' yw.properties 
done
#@end exec_yw_recon



#@begin exec_queries @desc execute prospective provenance queries.
#@in filename
#@in models
#@in facts
#@in views
#@param general_rules.P
#@param yw_views.P
#@param yw_graph_rules.P
#@param yw_jar_file


sh $QUERIES_DIR/queries.sh 



#@out results @uri file:results/{filename}.log
#@end exec_queries



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

