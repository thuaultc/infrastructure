#!/bin/bash

set -e

SCRIPT_NAME="$(basename $0)"

display_usage() {
  echo "usage: $SCRIPT_NAME <cluster-name> <online-token>"
  exit 1
}

if [ $# -lt 2 ]; then
  display_usage
fi

SCRIPT_PATH="$(cd "$(dirname "$0")"; pwd -P)"

DIRECTORY_PATH="$SCRIPT_PATH/../kubernetes/cluster"
DOCKER_TAG="infrastructure/kubernetes-cluster"

KUBERNETES_CONFIG_PATH="$DIRECTORY_PATH/../config"

# Arguments
CLUSTER_NAME=$1
ONLINE_TOKEN=$2

# Main
cd $DIRECTORY_PATH
echo "Building docker image..."
docker build --build-arg UID=`id -u` --build-arg GID=`id -g` -t $DOCKER_TAG . > /dev/null 2> /dev/null
echo "Launching image..."
docker run --rm -v $KUBERNETES_CONFIG_PATH:/config:rw -e ONLINE_TOKEN=$ONLINE_TOKEN -it $DOCKER_TAG generate $CLUSTER_NAME
