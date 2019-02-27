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

# Arguments
SERVER_HOSTNAME=$1
SERVER_IP=$2

# Main
SSH_HOME_DIRECTORY=~/.ssh
K8S_KEYS_DIRECTORY=k8s-keys

echo "Ensuring the ~/.ssh/k8s-node directory is created..."
mkdir -p $SSH_HOME_DIRECTORY/$K8S_KEYS_DIRECTORY

SSH_PRIVATE_KEY_PATH="$SSH_HOME_DIRECTORY/$K8S_KEYS_DIRECTORY/$SERVER_HOSTNAME-id_rsa"
SSH_PUBLIC_KEY_PATH="$SSH_PRIVATE_KEY_PATH.pub"

echo "Generating ssh key..."
ssh-keygen -t rsa -b 4096 -C "core@$SERVER_HOSTNAME" -f $SSH_PRIVATE_KEY_PATH -q -P ''

echo "Appending configuration to ~/.ssh/config..."
tee -a ~/.ssh/config <<EOF
Host $SERVER_HOSTNAME
  User core
  HostName $SERVER_IP
  Port 22
  IdentityFile ~/.ssh/$K8S_KEYS_DIRECTORY/$SERVER_HOSTNAME-id_rsa

EOF

SSH_PUBLIC_KEY=$(cat $SSH_PUBLIC_KEY_PATH)

echo "Configuring access to the machine $SERVER_HOSTNAME..."
ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR bootstrap@$SERVER_IP <<EOF
export SSH_PUBLIC_KEY="$SSH_PUBLIC_KEY"
echo $SSH_PUBLIC_KEY | sudo update-ssh-keys -a core -u core
EOF

echo "Trying to use the newly generated key..."
ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR $SERVER_HOSTNAME <<EOF
sudo userdel -f bootstrap
sudo systemctl enable docker.service
EOF
