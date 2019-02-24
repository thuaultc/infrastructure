#! /usr/bin/env python3
# encoding: utf-8

import os
import sys

import requests


class OnlineAPI(object):
    def __init__(self):
        self.__endpoint = 'https://api.online.net/api/v1'
        self.__token = os.getenv('ONLINE_TOKEN')
        self.__headers = {'Authorization': f'Bearer {self.__token}'}

    def check_rpn_group_exists(self, cluster_name):
        print(f'Checking that RPN group kubernetes-cluster-{cluster_name} exists...')
        r = requests.get(f'{self.__endpoint}/rpn/group', headers=self.__headers)

        if r.status_code != 200:
            print(f'error: HTTP status_code {r.status_code} when querying RPN groups (must be 200)', file=sys.stderr)
            print(f'output: {r.text}', file=sys.stderr)
            return None

        rpn_groups = r.json()

        for rpn_group in rpn_groups:
            if rpn_group['name'] == f'kubernetes-cluster-{cluster_name}':
                return rpn_group['id']

        return None

    def get_rpn_group(self, rpn_group_id):
        print(f'Retrieving RPN group {rpn_group_id}...')
        r = requests.get(f'{self.__endpoint}/rpn/group/{rpn_group_id}', headers=self.__headers)

        if r.status_code != 200:
            print(f'error: HTTP status_code {r.status_code} when querying RPN group (must be 200)', file=sys.stderr)
            print(f'output: {r.text}', file=sys.stderr)
            return None

        rpn_group = r.json()
        return rpn_group

    def create_rpn_group(self, cluster_name, server_id):
        print(f'Creating new RPN group kubernetes-cluster-{cluster_name} with server {server_id}...')
        payload = {
            'name': f'kubernetes-cluster-{cluster_name}',
            'server_ids': [server_id]
        }

        r = requests.post(f'{self.__endpoint}/rpn/group', headers=self.__headers, json=payload)

        if r.status_code != 200:
            print(f'error: HTTP status_code {r.status_code} when creating RPN group (must be 200)', file=sys.stderr)
            print(f'output: {r.text}', file=sys.stderr)
            return False

        return True

    def execute_rpn(self, action, rpn_group_id, server_id):
        print(f'Executing {action}Servers with {server_id} to RPN group {rpn_group_id}...')
        payload = {
            'group_id': rpn_group_id,
            'server_ids': [server_id]
        }

        r = requests.post(f'{self.__endpoint}/rpn/group/{action}Servers', headers=self.__headers, json=payload)

        if r.status_code != 200:
            print(f'error: HTTP status_code {r.status_code} when executing {action}Servers on RPN group (must be 200)', file=sys.stderr)
            print(f'output: {r.text}', file=sys.stderr)
            return False

        return True
