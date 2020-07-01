#!/bin/bash

message=$1

curl -X POST --data-urlencode "payload={\"channel\": \"#ngt-qa\", \"username\": \"webhookbot\", \"text\": \"$message\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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

