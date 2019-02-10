#!/bin/bash

set -e

SCRIPT_NAME="$(basename $0)"

display_usage() {
  echo "usage: $SCRIPT_NAME <server-hostname> <server-ip>"
  exit 1
}

if [ $# -lt 2 ]; then
  display_usage
fi

SCRIPT_PATH="$(cd "$(dirname "$0")"; pwd -P)"

DIRECTORY_PATH="$SCRIPT_PATH/../server/configure"
DOCKER_TAG="infrastructure/configure-server"

# Arguments
SERVER_HOSTNAME=$1
SERVER_IP=$2

# Main
cd $DIRECTORY_PATH
echo "Building docker image..."
docker build --build-arg UID=`id -u` --build-arg GID=`id -g` -t $DOCKER_TAG . > /dev/null 2> /dev/null
echo "Launching image..."
docker run --rm -v $HOME/.ssh:/home/user/.ssh:rw -it $DOCKER_TAG $SERVER_HOSTNAME $SERVER_IP
