#!/bin/bash

set -e

TERRAFORM_VERSION="0.11.11"
DOCKER_TERRAFORM="docker run --rm -v $(pwd):/app/ -w /app/ -it hashicorp/terraform:$TERRAFORM_VERSION"

$DOCKER_TERRAFORM init
$DOCKER_TERRAFORM apply