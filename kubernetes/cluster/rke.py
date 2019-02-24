#! /usr/bin/env python3
# encoding: utf-8

import os
import sys
import yaml


class Config(object):
    def __init__(self):
        self.__cluster_base_config_path = os.path.abspath(os.getenv('RKE_CLUSTER_BASE_CONFIG_PATH'))
        self.__output_config_directory_path = os.path.abspath(os.getenv('RKE_OUTPUT_CONFIG_PATH'))

    def generate(self, cluster_name, rpn_group):
        print(f'Generating config for cluster {cluster_name}...')

        cluster_config = {}

        with open(self.__cluster_base_config_path, 'r') as file_handler:
            try:
                cluster_config = yaml.load(file_handler)
            except yaml.YAMLError as e:
                print(f'error: Could not parse YAML file {self.__cluster_base_config_path}', file=sys.stderr)
                print(f'output: {e}', file=sys.stderr)
                return False

        cluster_config['services']['kubelet']['cluster_domain'] = f'{cluster_name}.local'

        cluster_config['nodes'] = []
        for node in rpn_group['members']:
            cluster_config['nodes'].append({
                'address': node['ip'],
                'internal_address': node['private_ip'],
                'port': '22',
                'role': ['controlplane', 'worker', 'etcd'],
                'hostname_override': f'k8s-node-{node["id"]}',
                'user': 'core',
                'docker_socket': '/var/run/docker.sock',
                'ssh_key': '',
                'ssh_key_path': f'~/.ssh/k8s-keys/k8s-node-{node["id"]}-id_rsa',
                'labels': {}
            })

        output_config_path = os.path.join(self.__output_config_directory_path, f'{cluster_name}_cluster.yml')
        print(output_config_path)
        with open(output_config_path, 'w') as file_handler:
            try:
                yaml.dump(cluster_config, file_handler, default_flow_style=False)
            except yaml.YAMLError as e:
                print(f'error: Could not create YAML file {output_config_path}', file=sys.stderr)
                print(f'output: {e}', file=sys.stderr)
                return False