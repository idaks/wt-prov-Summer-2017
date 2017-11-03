# define base directories
export BASE_DIR="D:\Study\Internship\WT_PaleoCar_2017\meteor_example\wt-prov-summer-2017"
export YW_DIR=${BASE_DIR}/yw


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



# define lcoation of YesWorkflow jar file
export YW_JAR="${BASE_DIR}/yw/yw_jar/yesworkflow-0.2.1.1-jar-with-dependencies.jar"
export YW_MATLAB_JAR="${BASE_DIR}/yw/yw_jar/yesworkflow-0.2.1.1-jar-with-dependencies.jar"

## define command for running YesWorkflow
export YW_CMD="java -jar $YW_JAR"
#export YW_MATLAB_RECON_CMD="java -jar $YW_MATLAB_JAR"

# location of shared Prolog rules, scripts, and queries
export RULES_DIR=${BASE_DIR}/yw/rules
export QUERIES_DIR=${BASE_DIR}/yw/queries

# destination of facts, views and query results
export SCRIPT_DIR=${BASE_DIR}/Rscript
export FACTS_DIR=${BASE_DIR}/yw/facts
export MODEL_DIR=${BASE_DIR}/yw/models
export RECON_DIR=${BASE_DIR}/yw/recon
export VIEWS_DIR=${BASE_DIR}/yw/views
export RESULTS_DIR=${BASE_DIR}/yw/results

export GRAPH_PDF_DIR=${BASE_DIR}/yw/pdf
export GRAPH_SVG_DIR=${BASE_DIR}/yw/svg
export GRAPH_PNG_DIR=${BASE_DIR}/yw/png
export GRAPH_DOT_DIR=${BASE_DIR}/yw/dot


mkdir -p $GRAPH_PDF_DIR $GRAPH_SVG_DIR_DIR $GRAPH_PNG_DIR $GRAPH_DOT_DIR $FACTS_DIR $MODEL_DIR $RECON_DIR $VIEWS_DIR $RESULTS_DIR  

#alias yw="java -jar ${YW_JAR}"