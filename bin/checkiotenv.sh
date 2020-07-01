#!/bin/bash

curl -L --max-time 5 -s -o /dev/null -I -w "%{http_code}" http://172.24.245.75:80/ | \
	awk '{print "env_status " $1 }' | \
	curl --insecure -v --data-binary @- $PUSH_GATE/metrics/job/environment_status
