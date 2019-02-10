# :bullettrain_side: Infrastructure

This repository contains scripts for infrastructure creation and kubernetes cluster management.

## What's in there ?

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

Simply execute the `scripts/install-server.sh` script with the following arguments:

```bash
$ ./install-server.sh <server-id> <online-token> <partitioning-template>
```

This will launch the installation of CoreOS - Alpha on the <server-id> machine, with a password randomly generated for the user `bootstrap`.

The password will be printed for the next step: configuring access to the machine, once the installation is over (may take up to an hour).

#### SSH keys

The installation on Online.net does not correctly install SSH keys

Install a server on Online.net, and outputs

## Kubernetes - RKE


## DNS - Terraform

### Requirements

* docker (running terraform v0.11.11)

### Credentials

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

Simply execute the `apply.sh` script from the `dns` directory.

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

The script will execute terraform using docker, and will run the `init` and `apply` commands.

## Author

* **Clément Thuault** - [thuaultc](https://github.com/thuaultc)
