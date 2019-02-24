#!/bin/bash

set -e

SCRIPT_NAME="$(basename $0)"

display_usage() {
  echo "usage: $SCRIPT_NAME <ovh-application-key> <ovh-application-secret> <ovh-consumer-key>"
  exit 1
}

if [ $# -lt 3 ]; then
  display_usage
fi

SCRIPT_PATH="$(cd "$(dirname "$0")"; pwd -P)"

DIRECTORY_PATH="$SCRIPT_PATH/../dns"

# Arguments
OVH_APPLICATION_KEY=$1
OVH_APPLICATION_SECRET=$2
OVH_CONSUMER_KEY=$3

# Main
TERRAFORM_VERSION="0.11.11"
ENVIRONMENT_VARIABLES="-e OVH_APPLICATION_KEY=$OVH_APPLICATION_KEY -e OVH_APPLICATION_SECRET=$OVH_APPLICATION_SECRET -e OVH_CONSUMER_KEY=$OVH_CONSUMER_KEY"
DOCKER_TERRAFORM_COMMAND="docker run --rm $ENVIRONMENT_VARIABLES -v $DIRECTORY_PATH:/app/:rw -w /app/ -it hashicorp/terraform:$TERRAFORM_VERSION"

echo "Initializing terraform..."
$DOCKER_TERRAFORM_COMMAND init
echo "Applying terraform state..."
$DOCKER_TERRAFORM_COMMAND apply