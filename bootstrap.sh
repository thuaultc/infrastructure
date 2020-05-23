#!/bin/bash

set -e

git clone git://github.com/thuaultc/infrastructure.git
infrastructure/install.sh > install.log 2>&1
