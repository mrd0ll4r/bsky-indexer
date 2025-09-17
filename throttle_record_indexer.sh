#!/bin/bash -e

echo "It's now $(date -u), checking delay and adjusting workers if needed..."
source .env
echo "Reading from Prometheus at $VPN_IP:9090..."

current_max_delay=$(curl -s -X POST --data-urlencode 'query=time() - label_replace(repo_commit_received_timestamp{job="indexer",remote=~"https://(.*\\.)?bsky\\.(network|social)"}, "remote", "$1", "remote", "https://((?U).*)(\\.host\\.bsky\\.network)?")' http://$VPN_IP:9090/api/v1/query | jq '[.data.result[].value[1] | tonumber | floor] | max')

if [[ "$current_max_delay" -gt "600" ]]; then
	echo "delay is $current_max_delay, which is too big! Setting workers low..."
	curl -s 'http://localhost:11003/pool/resize?size=20'
else
	echo "delay is okay, setting workers high..."
	curl -s 'http://localhost:11003/pool/resize?size=75'
fi 

echo ""
