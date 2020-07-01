#!/bin/bash

echo "Sending chrome metrics"
ps -ef | pgrep chrom | wc -l | awk '{print "ngt_chrome_instances " $1  }' | curl --data-binary @- $PUSH_GATE/metrics/job/ngt_chrome

