#!/bin/bash
set -e

DOCKER_TERRAFORM="docker run -it -v $(pwd):/app/ -w /app/ hashicorp/terraform:0.11.11"

$DOCKER_TERRAFORM init
$DOCKER_TERRAFORM apply
