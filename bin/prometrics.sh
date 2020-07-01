#!/bin/bash
REPORT=/new-QA/new-QA/reports/json-report
FILE=$REPORT/result.json
DATE=$(date +"%F-%H-%M-%S")
# Validate & push the metrics
if [ -f $FILE ]; then
    echo "File $FILE exists."
    #cp -r /new-QA/new-QA/reports/html-report/*  /root/new-QA/HttpShared/
    #cp -r /new-QA/new-QA/reports/html-report /root/new-QA/HttpShared/$METRIC_COMPL/html-report.$DATE.$METRIC_COMPL
    cp -r /new-QA/new-QA/reports/html-report/* /root/new-QA/HttpShared/$JOB_NAME/html-report.latest
    # Extract a nice json from last report
    #jq -r '.projectName as $project |.environment as $env | .specResults[] |"new_QA {env=\"\($env)\", spec=\"\(.specHeading|gsub("\"";"\\\""))\", result=\"\(.executionStatus)\"} \(.executionTime)"' | \
    #jq -r '.projectName as $project |.environment as $env | .specResults[] |.specHeading as $spec| .scenarios[] |.scenarioHeading as $scen|.items[]| select(.itemType=="step") |.stepText as $step|"new_QA_'$METRIC_COMPL'{env=\"\($env)\", project=\"\($project|gsub("\"";"\\\""))\", operation=\"du\", spec=\"\($spec|gsub("\"";"\\\""))\", scenario=\"\($scen|gsub("\"";"\\\""))\", step=\"\($step|gsub("\"";"\\\""))\", result=\"\(.result.status)\"}  \(.result.executionTime)"' | \   
    #ALL THE STEPS
    { cat $REPORT/result.json | \
    jq -r '.projectName as $project |.environment as $env | .specResults[] |.specHeading as $spec | .executionStatus as $spec_result | .scenarios[] |.scenarioHeading as $scen | .executionStatus as $scenario_result | .items[],.teardowns[],.contexts[]| select(.itemType=="step") |.stepText as $step|"new_QA_'$METRIC_COMPL'{env=\"\($env)\", project=\"\($project|gsub("\"";"\\\""))\", operation=\"du\", type=\"step\", spec=\"\($spec|gsub("\"";"\\\""))\", scenario=\"\($scen|gsub("\"";"\\\""))\", step=\"\($step|gsub("\"";"\\\""))\", result=\"\(.result.status)\", spec_result=\"\($spec_result)\", scenario_result=\"\($scenario_result)\" }  \(.result.executionTime)"' ; \
    #ALL THE CONCEPTS STEPS
    cat $REPORT/result.json | \
    jq -r '.projectName as $project |.environment as $env | .specResults[] |.specHeading as $spec | .executionStatus as $spec_result | .scenarios[] |.scenarioHeading as $scen | .executionStatus as $scenario_result |  .items[],.teardowns[],.contexts[]| select(.itemType=="concept") | .conceptStep |.stepText as $step|"new_QA_'$METRIC_COMPL'{env=\"\($env)\", project=\"\($project|gsub("\"";"\\\""))\", operation=\"du\",type=\"concept_step\" , spec=\"\($spec|gsub("\"";"\\\""))\", scenario=\"\($scen|gsub("\"";"\\\""))\", step=\"\($step|gsub("\"";"\\\""))\", result=\"\(.result.status)\", spec_result=\"\($spec_result)\", scenario_result=\"\($scenario_result)\" }  \(.result.executionTime)"' ; } | \
    # Send to the metric server
    curl --insecure -v --data-binary @- $PUSH_GATE/metrics/job/ngt_$JOB_NAME
    name=`uname -n`
    timestamp=`date +%s`
    result=`jq -r '.executionStatus' $REPORT/result.json`
    echo "prometrics_exec_$METRIC_COMPL{name=\"$name\",env=\"$ENV\", result=\"$result\"} $timestamp" | curl --insecure --data-binary @- $PUSH_GATE/metrics/job/ngt_prometrics_$JOB_NAME
    
    # usermod -u 101 /root/new-QA/HttpShared/
    cd /root/new-QA/HttpShared/ & chown 101:101 -R *

else
   echo "File $FILE does not exist."
fi
