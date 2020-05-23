#!/bin/bash

set -e

git clone -o StrictHostKeyChecking=no git@github.com:thuaultc/infrastructure.git

infrastructure/server/install.sh > install.log 2>&1
