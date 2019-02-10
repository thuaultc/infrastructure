#! /usr/bin/env python3
# encoding: utf-8

import json
import os
import sys

import requests


class OnlineAPI(object):
    def __init__(self):
        self.__endpoint = 'https://api.online.net/api/v1'
        self.__token = os.getenv('ONLINE_TOKEN')
        self.__headers = {'Authorization': 'Bearer {}'.format(self.__token)}

    def check_server_exists(self, server_id):
        print(f'Checking that server {server_id} exists...')
        r = requests.get('{}/server'.format(self.__endpoint), headers=self.__headers)

        if r.status_code != 200:
            print(f'error: HTTP status_code {r.status_code} when querying servers (must be 200)', file=sys.stderr)
            print(f'output: {r.text}', file=sys.stderr)
            return False

        server_ids = [server.split('/')[-1] for server in r.json()]

        if server_id not in server_ids:
            print(f'error: server_id {server_id} was not found among your servers', file=sys.stderr)
            return False

        return True

    def install_server(self, server_id, partitioning_template, bootstrap_password):
        print(f'Installing server {server_id}...')
        payload = {
            'os_id': 314, # CoreOS - Alpha
            'hostname': f'k8s-node-{server_id}',
            'send_mail_monitoring': 'true',
            'send_mail_new_os_version': 'false',
            'user_login': 'bootstrap',
            'user_password': bootstrap_password,
            'root_password': '',
            'panel_password': '',
            'partitioning': [],
            'partitioning_template_ref': partitioning_template,
            'ssh_keys': []
        }

        r = requests.post(f'{self.__endpoint}/server/install/{server_id}', headers=self.__headers, json=payload)

        if r.status_code != 201:
            print(f'error: HTTP status code {r.status_code} when installing server (must be 201)', file=sys.stderr)
            print(f'output: {r.text}', file=sys.stderr)
            return False

        return True

    def get_server_ip(self, server_id):
        print(f'Retrieving IP address for server {server_id}...')
        r = requests.get(f'{self.__endpoint}/server/{server_id}', headers=self.__headers)

        if r.status_code != 200:
            print(f'error: HTTP status_code {r.status_code} when querying server {server_id} (must be 200)', file=sys.stderr)
            print(f'output: {r.text}', file=sys.stderr)
            return None

        try:
            public_ip = [
                ip['address']
                for ip in r.json()['ip']
                if ip['type'] == 'public'
            ][0]
            return public_ip
        except:
            print(f'error: could not find a public IP address in the response payload', file=sys.stderr)
            print(f'output: {r.text}', file=sys.stderr)
            return None