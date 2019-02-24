#! /usr/bin/env python3
# encoding: utf-8

import sys

import api
import rke


def parse_args():
    if not 3 <= len(sys.argv) <= 4:
        print(f'usage: {sys.argv[0]} <add|remove|generate> <cluster-name> [server-id]', file=sys.stderr)
        sys.exit(1)

    action, cluster_name = sys.argv[1:3]

    if action not in ['add', 'remove', 'generate']:
        print('error: invalid action found, must be one of: <add|remove|generate>', file=sys.stderr)
        sys.exit(1)

    server_id = None
    if len(sys.argv) == 4:
        server_id = sys.argv[3]

    return action, cluster_name, server_id


if __name__ == '__main__':
    action, cluster_name, server_id = parse_args()

    online_api = api.OnlineAPI()

    rpn_group_id = online_api.check_rpn_group_exists(cluster_name)
    if rpn_group_id:
        rpn_group = online_api.get_rpn_group(rpn_group_id)

        if action != 'generate':
            if not online_api.execute_rpn(action, rpn_group_id, server_id):
                sys.exit(1)
    else:
        if action == 'remove':
            print(f'error: could not remove server {server_id} because RPN group does not exist', file=sys.stderr)
            sys.exit(1)
        elif action == 'add':
            if not online_api.create_rpn_group(cluster_name, server_id):
                sys.exit(1)
        else:
            print(f'error: cannot generate RKE config if RPN group does not exist', file=sys.stderr)
            sys.exit(1)

        rpn_group_id = online_api.check_rpn_group_exists(cluster_name)
        if not rpn_group_id:
            print('unexpected error: could not find RPN group', file=sys.stderr)

    if action != 'generate':
        rpn_group = online_api.get_rpn_group(rpn_group_id)
        if not rpn_group:
            print('unexpected error: could not get RPN group data', file=sys.stderr)

    rke_config = rke.Config()
    rke_config.generate(cluster_name, rpn_group)