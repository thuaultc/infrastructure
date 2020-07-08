#!/bin/bash

set -e

apt update
apt install -y ansible

echo "[server]" >> /etc/ansible/hosts
echo "$HOSTNAME ansible_host=127.0.0.1" >> /etc/ansible/hosts

ansible-playbook /root/infrastructure/server/install.yml
