# :bullettrain_side: Infrastructure

This repository contains scripts for infrastructure creation and kubernetes cluster management.

## What's in there ?

* **kubernetes:** Kubernetes cluster management using RKE

## Kubernetes

### Prerequisites

* Install `rke` (tested with v1.0.4)

### Usage

This will create a k8s cluster and generate kubeconfig and rkestate files:
```bash
$ cd kubernetes
$ rke up --ssh-agent-auth
```

Use the generated kubeconfig in kubectl:
```bash
$ cp kube_config_cluster.yml ~/.kube/config

$ kubectl get nodes
NAME             STATUS   ROLES                      AGE    VERSION
k8s-node-12345   Ready    controlplane,etcd,worker   110s   v1.12.4
```

### Edge cases

* We need to do `sudo sysctl net.ipv4.conf.all.rp_filter=0` to allow calico network plugin to work correctly.
* If CoreDNS fails to start as well, check for DNS resolv loops and remove 127.0.0.1 in /etc/resolv/.conf since it's not needed.

## Author

* **Clément Thuault** - [thuaultc](https://github.com/thuaultc)
