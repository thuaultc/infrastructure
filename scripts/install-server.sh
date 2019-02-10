#!/bin/bash

set -e

SCRIPT_NAME="$(basename $0)"

display_usage() {
  echo "usage: $SCRIPT_NAME <server-id> <online-token> <partitioning-template>"
  exit 1
}

if [ $# -lt 3 ]; then
  display_usage
fi

SCRIPT_PATH="$(cd "$(dirname "$0")"; pwd -P)"

DIRECTORY_PATH="$SCRIPT_PATH/../server/install"
DOCKER_TAG="infrastructure/install-server"

# Arguments
SERVER_ID=$1
ONLINE_TOKEN=$2
PARTITIONING_TEMPLATE=$3

# Main
cd $DIRECTORY_PATH
echo "Building docker image..."
docker build -t $DOCKER_TAG . > /dev/null 2> /dev/null
echo "Launching image..."
docker run -e ONLINE_TOKEN=$ONLINE_TOKEN --rm $DOCKER_TAG $SERVER_ID $PARTITIONING_TEMPLATE
