set port=80

set CP=./jars;./jars/*
set warFile=./jars/form-modelregistration-1.0.war

java -Dorg.eclipse.jetty.util.UrlEncoding.charset=UTF-8 -cp %CP% -Dorg.apache.jasper.compiler.disablejsr199=true StandaloneServer %port% %warFile%

pause