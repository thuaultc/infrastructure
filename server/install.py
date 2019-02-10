#! /usr/bin/env python3
# encoding: utf-8

import random
import string
import sys

import api


def generate_password(password_length):
    return ''.join(
        random.SystemRandom().choices(string.ascii_lowercase + string.digits, k=password_length)
    )

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print(f"usage: {sys.argv[0]} <server-id> <partitioning-template>", file=sys.stderr)
        sys.exit(1)

    server_id, partitioning_template = sys.argv[1:3]
    online_api = api.OnlineAPI()

    if not online_api.check_server_exists(server_id):
        sys.exit(1)

    server_ip = online_api.get_server_ip(server_id)
    if not server_ip:
        sys.exit(1)

    random_password = generate_password(20)
    if not online_api.install_server(server_id, partitioning_template, random_password):
        sys.exit(1)

    print("\nServer successfully installed! You might have to wait up to 1h to connect to it.\n")
    print(f"Hostname: k8s-node-{server_id}")
    print(f"IP Address: {server_ip}")
    print("Username: bootstrap")
    print(f"Password: {random_password}")