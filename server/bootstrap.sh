#!/bin/bash

set -e

ssh-keyscan -H github.com >> ~/.ssh/known_hosts
git clone git@github.com:thuaultc/infrastructure.git

infrastructure/server/install.sh > install.log 2>&1
