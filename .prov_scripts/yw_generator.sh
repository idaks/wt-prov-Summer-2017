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

#echo "pratik"

 alias yw="java -jar /d/Study/Internship/WT_PaleoCar_2017/YesWorkflow/yesworkflow-0.2.1.1-jar-with-dependencies.jar"
 
 #yw --help 
 #doT --version 

echo $1

dir="/d/Study/Internship/WT_PaleoCar_2017/meteor_example/wt-prov-summer-2017/.Prov_Scripts/"

cd $dir

#mkdir $output 

for file in `ls -a *.R` ;
do
 echo $file 
 yw graph -c graph.view=combined $file > gv_files/${file:0:${#file}-2}.gv
 yw graph -c graph.view=combined $file | dot -Tpdf -o prov_pdf/${file:0:${#file}-2}.pdf
 yw graph -c graph.view=combined $file | dot -Tpng -o graphs/${file:0:${#file}-2}.png
 yw graph -c graph.view=combined $file | dot -Tsvg -o svg_files/${file:0:${#file}-2}.svg
done
#yw graph   | doT -Tpng -o ${1}.png 
