# :bullettrain_side: Infrastructure

This repository contains scripts for infrastructure creation and kubernetes cluster management.

## What's in there ?

* **scripts:** Automation scripts used to create infrastructure
* **server:** Server installation on Online.net
* **kubernetes:** Kubernetes cluster management using RKE
* **dns:** OVH DNS zone management with Terraform

## Server - Online.net

### Pre-requisites

#### Credentials

Get your private token on the Online.net console, available [here](https://console.online.net/fr/api/access) to use the API with this script.

#### Partitioning template

You'll also need to create a linux partitioning template on the console, [here](https://console.online.net/fr/template/partition). Keep the ID, we'll also need it.

### Usage

#### Installation

Simply execute the `scripts/server-install.sh` script with the following arguments:

```bash
$ ./scripts/server-install.sh <server-id> <online-token> <partitioning-template>
```

This will launch the installation of CoreOS on the <server-id> machine, with a password randomly generated for the user `bootstrap`.

```
Building docker image...
Launching image...
Checking that server 12345 exists...
Retrieving IP address for server 12345...
Installing server 12345...

Server successfully installed! You might have to wait up to 1h to connect to it.

Hostname: k8s-node-12345
IP Address: 123.234.1.234
Username: bootstrap
Password: <password>
```

The password is printed for the next step: configuring access to the machine, once the installation is over (may take up to an hour).

#### Configuration

The installation on Online.net does not correctly install SSH keys, and this still needs to be configured.

Once the server is installed, you may launch the `scripts/server-configure.sh` script with the following arguments:

```bash
$ ./scripts/server-configure.sh <server-hostname> <server-ip>
```

This will generate a SSH keypair for your machine, and automatically add it to your .ssh directory in your $HOME, while generating the correct configuration.

```
Building docker image...
Launching image...
Ensuring the ~/.ssh/k8s-node directory is created...
Generating ssh key...
Appending configuration to ~/.ssh/config...
Host k8s-node-12345
  User core
  HostName 123.234.1.234
  Port 22
  IdentityFile ~/.ssh/k8s-keys/k8s-node-12345-id_rsa

Configuring access to the machine k8s-node-85539...
Password:
Container Linux by CoreOS alpha (2051.0.0)
Adding/updating core:
4096 SHA256:xnczCN+Wil6gJKh3sHq6VnTUaOjDKaWjk/Tona6gJ5U core@k8s-node-12345 (RSA)
Updated "/home/core/.ssh/authorized_keys"
Trying to use the newly generated key...
Container Linux by CoreOS alpha (2051.0.0)
```

## Kubernetes - RKE

### Pre-requisites

You must have at least one node already installed and configured, with your SSH keys correctly generated and set up.

Your nodes must also be RPN v1 compatible.

### Usage

The following scripts can be used for each node, either one installation after the other, or all at the same time.

#### Add or remove a node and update RKE config

Simply execute the `scripts/kubernetes-cluster-{add,remove}.sh` script with the following arguments:

```bash
$ ./scripts/kubernetes-cluster-add.sh <cluster-name> <server-id> <online-token>
```

This will add/remove your node to the RPN group named 'kubernetes-cluster-<cluster-name>', and generate the RKE cluster.yml config corresponding to this group. This configuration is then available in a specific config/ directory for later use.

```
Building docker image...
Launching image...
Checking that RPN group kubernetes-cluster-asgard exists...
Creating new RPN group kubernetes-cluster-asgard with server 12345...
Checking that RPN group kubernetes-cluster-asgard exists...
Retrieving RPN group 10000...
Generating config for cluster example...
Config generated in /config/example_cluster.yml

```

#### Generate RKE config

In some cases, if the RPN group is correctly setup but no modification needs to be done, simply execute the `scripts/kubernetes-cluster-generate.sh` script with the following arguments:

```bash
$ ./scripts/kubernetes-cluster-generate.sh <cluster-name> <online-token>
```

No RPN group action will be made, only the RKE configuration will be recreated.

#### Apply RKE config

Once the RKE config has been generated, execute the `scripts/kubernetes-apply.sh` script with the following arguments:

```bash
$ ./scripts/kubernetes-apply.sh <cluster-name>
```

This will execute `rke up` with the corresponding cluster.yml file generated previously. It should ensure an idempotent update of your cluster.

```
Building docker image...
Launching image...
INFO[0000] Building Kubernetes cluster
INFO[0000] [dialer] Setup tunnel for host [123.234.1.234]
[...]
INFO[0165] Finished building Kubernetes cluster successfully
```

The basic configuration used for the cluster is available in `kubernetes/cluster/cluster-base.yml`, nodes are automatically generated with the information found in the RPN Online.net API call.

Once the command finishes successfully, simply copy the generated kubeconfig file to start executing commands against your brand new cluster:

```bash
$ ls kubernetes/config
example_cluster.yml  kube_config_example_cluster.yml

$ cp kubernetes/config/kube_config_example_cluster.yml ~/.kube/config

$ kubectl get nodes
NAME             STATUS   ROLES                      AGE    VERSION
k8s-node-12345   Ready    controlplane,etcd,worker   110s   v1.12.4
```

## DNS - Terraform

### Pre-requisites

Create an OVH Application access and secret key [here](https://eu.api.ovh.com/createApp/), then request an authentication token from OVH using the following request:

```bash
$ curl -XPOST -H "X-Ovh-Application: <application-token>" -H "Content-type: application/json" \
https://eu.api.ovh.com/1.0/auth/credential -d '{
  "accessRules": [
    {
      "method": "DELETE",
      "path": "/domain/zone/*"
    },
    {
      "method": "GET",
      "path": "/domain/zone/*"
    },
    {
      "method": "POST",
      "path": "/domain/zone/*"
    },
    {
      "method": "PUT",
      "path": "/domain/zone/*"
    },
    {
      "method": "GET",
      "path": "/domain/*"
    },
    {
      "method": "PUT",
      "path": "/domain/*"
    }]
}'
```

This registers the application token to your account with the corresponding access rights.

### Usage

Simply execute the `scripts/dns-apply.sh` script with the following arguments:


```bash
$ ./scripts/dns-apply.sh <ovh-application-key> <ovh-application-secret> <ovh-consumer-key>
```

The script will execute terraform using docker, and will run the `init` and `apply` commands.

```bash
$ cd ovh 
$ ./apply.sh 
Initializing modules...
- module.ovh-a-record_thuault

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
data.ovh_domain_zone.root_zone: Refreshing state...
ovh_domain_zone_record.dns_zone: Refreshing state... (ID: 1588765345)

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

## Author

* **Clément Thuault** - [thuaultc](https://github.com/thuaultc)
