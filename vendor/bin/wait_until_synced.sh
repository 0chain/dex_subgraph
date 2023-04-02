#!/bin/bash

# This script is used to check if a subgraph with the given name is synchronized.
# It requires two positional arguments to be given. 
# The first one is a URL for the status GraphQL server of the graph node.
# The second one is a name of the subgraph.

while true; do
	RESPONSE=$(curl -s -d '{ "query": "{ indexingStatusForCurrentVersion(subgraphName:\"'${2}'\"){ synced } }" }' "${1}" | jq -r '.data.indexingStatusForCurrentVersion.synced');
	if [ $RESPONSE = "true" ]; then
		echo "DEX subgraph is synced";
		break;
	else
		sleep 1;
	fi 
done