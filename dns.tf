locals {
  dns_name = "dip-net.dev."
}
resource "google_dns_managed_zone" "dip_network" {
  name        = "dip-network-zone"
  dns_name    = local.dns_name
  description = "Private DNS zone for Eros Network"
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.commercial_network.id
    }
  }
}

resource "google_dns_record_set" "ilus" {
  name         = "support.${local.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.dip_network.name
  rrdatas      = [google_compute_address.this["support"].address]
}
resource "google_dns_record_set" "vera" {
  name         = "operation.${local.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.dip_network.name
  rrdatas      = [google_compute_address.this["operation"].address]
}