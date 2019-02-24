#!/bin/bash

set -e

SCRIPT_NAME="$(basename $0)"

display_usage() {
  echo "usage: $SCRIPT_NAME <cluster-name>"
  exit 1
}

if [ $# -lt 1 ]; then
  display_usage
fi

SCRIPT_PATH="$(cd "$(dirname "$0")"; pwd -P)"

DIRECTORY_PATH="$SCRIPT_PATH/../kubernetes/apply"
DOCKER_TAG="infrastructure/kubernetes-apply"

KUBERNETES_CONFIG_PATH="$DIRECTORY_PATH/../config"

# Arguments
CLUSTER_NAME=$1

# Main
cd $DIRECTORY_PATH
echo "Building docker image..."
docker build --build-arg UID=`id -u` --build-arg GID=`id -g` -t $DOCKER_TAG .
echo "Launching image..."
docker run --rm -v $HOME/.ssh:/home/user/.ssh:ro -v $KUBERNETES_CONFIG_PATH:/config:rw -it $DOCKER_TAG up --config /config/${CLUSTER_NAME}_cluster.yml
