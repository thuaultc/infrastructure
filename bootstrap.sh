#!/bin/bash

set -e

git clone git://github.com/thuaultc/infrastructure.git /root/infrastructure
/root/infrastructure/install.sh > /root/install.log 2>&1

echo "INSTALL OK"
