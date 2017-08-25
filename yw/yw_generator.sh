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
 

dir="/d/Study/Internship/WT_PaleoCar_2017/meteor_example/wt-prov-summer-2017"


cd ${dir}/yw

rm -rf prov_pdf/* svg_files/* gv_files/* graphs/* 

cd ${dir}/Rscript

for file in `ls -1 *.R  *.java ` ;
do

 echo $file 
 
 filename=`ls -1 $file | sed -e 's/\..*$//' `
 yw graph $file > ${dir}/yw/gv_files/${filename}.gv
 yw graph $file | dot -Tpdf -o ${dir}/yw/prov_pdf/${filename}.pdf
 yw graph $file | dot -Tpng -o ${dir}/yw/graphs/${filename}.png
 yw graph $file | dot -Tsvg -o ${dir}/yw/svg_files/${filename}.svg

 yw extract -c extract.factsfile $file > ${dir}/yw/facts/${filename}.P
 yw model   -c model.factsfile   $file > ${dir}/yw/models/${filename}.P
 
done

cd ${dir}/yw

# genereate the views and execute YW queries for the model. 
sh yw_views.sh 

sh yw_queries.sh 

## Execute the YW recon for the model

cd ${dir}/Rscript

for file in `ls -1 *.R  *.java ` ;
do
 filename=`ls -1 $file | sed -e 's/\..*$//' `
 sed -i -e 's|#extract.sources     = ../Rscript/file|'"extract.sources     = ../Rscript/${file}"'|g' yw.properties 
 sed -i -e 's|#recon.factsfile     = ../yw/recon/file|'"recon.factsfile     = ../yw/recon/${filename}.P"'|g' yw.properties 
 yw recon
 sed -i -e 's|'"extract.sources     = ../Rscript/${file}"'|#extract.sources     = ../Rscript/file|g' yw.properties 
 sed -i -e 's|'"recon.factsfile     = ../yw/recon/${filename}.P"'|#recon.factsfile     = ../yw/recon/file|g' yw.properties 
done
