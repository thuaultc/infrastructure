terraform {
  version = "~> 0.11.11"
}

data "ovh_domain_zone" "root_zone" {
  name = "thuault.com"
}

resource "ovh_domain_zone_record" "dns_zone" {
  zone      = "${data.ovh_domain_zone.root_zone.name}"
  subdomain = "${var.subdomain}"
  fieldtype = "A"
  target    = "${var.target}"
}
