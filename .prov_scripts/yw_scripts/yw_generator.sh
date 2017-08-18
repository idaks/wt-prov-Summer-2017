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
 

dir="/d/Study/Internship/WT_PaleoCar_2017/meteor_example/wt-prov-summer-2017/.Prov_Scripts/yw_scripts/"


cd $dir

rm -rf ../prov_pdf/* ../svg_files/* ../gv_files/* ../graphs/* 

for file in `ls -1  *.R *.java ` ;
do

 echo $file 
 filename=`ls -1 $file | sed -e 's/\..*$//' `
 yw graph $file > ../gv_files/${filename}.gv
 yw graph $file | dot -Tpdf -o ../prov_pdf/${filename}.pdf
 yw graph $file | dot -Tpng -o ../graphs/${filename}.png
 yw graph $file | dot -Tsvg -o ../svg_files/${filename}.svg

 yw extract -c extract.factsfile $file > ../facts/${filename}.P
 yw model   -c model.factsfile   $file > ../models/${filename}.P
 
done
#yw graph   | doT -Tpng -o ${1}.png 
