# :bullettrain_side: Infrastructure

This repository contains scripts for infrastructure creation and kubernetes cluster management.

## What's in there ?

* **online:** Server installation on Online.net
* **kubernetes:** Kubernetes cluster management using RKE
* **ovh:** OVH DNS zone management with Terraform

## OVH - Terraform

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

Simply execute the `apply.sh` script from the `ovh` directory.

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

## Authors

* **Clément Thuault** - [thuaultc](https://github.com/thuaultc)
