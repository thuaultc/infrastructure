terraform {
  version = "~> 0.11.11"
}

provider "ovh" {
  version            = "~> 0.3"
  endpoint           = "ovh-eu"
  application_key    = "udKnoJbZr4ajq7eS"
  application_secret = "BhRDnOIlYRQJMUtnJE5BN18y6Q4oAM9g"
  consumer_key       = "L8GQVYlq1ps3UpOOGDhK6e5eM9OmEyxq"
}

module "ovh-a-record_thuault" {
  source    = "modules/ovh-a-record"
  subdomain = ""
}

module "ovh-a-record_bring_it" {
  source    = "modules/ovh-a-record"
  subdomain = "bring-it"
}

module "ovh-a-record_api_bring_it" {
  source    = "modules/ovh-a-record"
  subdomain = "api.bring-it"
}

module "ovh-a-record_k8s" {
  source    = "modules/ovh-a-record"
  subdomain = "k8s"
}

module "ovh-a-record_la_quete" {
  source    = "modules/ovh-a-record"
  subdomain = "la-quete"
}

module "ovh-a-record_minecraft" {
  source    = "modules/ovh-a-record"
  subdomain = "minecraft"
}

module "ovh-a-record_registry" {
  source    = "modules/ovh-a-record"
  subdomain = "registry"
}

module "ovh-a-record_speed_dial" {
  source    = "modules/ovh-a-record"
  subdomain = "speed-dial"
}
