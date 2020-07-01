#!/bin/bash
echo $(date)
echo $CASES
echo $ENV
echo $METRIC_COMPL
cd /new-QA/new-QA && git pull
cd /new-QA/new-QA && mvn clean
cd /new-QA/new-QA && mvn package -DskipTests 
cd /new-QA/new-QA && mvn gauge:execute -DspecsDir=specs/$CASES -Denv=$ENV
sh /new-QA/new-QA/bin/prometrics.sh
sh /new-QA/new-QA/bin/checkiotenv.sh
