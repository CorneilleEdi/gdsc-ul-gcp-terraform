resource "google_compute_network" "commercial_network" {
  name                    = "commercial-network"
  auto_create_subnetworks = false
}

resource "google_compute_network" "finance_network" {
  name                    = "finance-network"
  auto_create_subnetworks = false
}

#resource "google_compute_network_peering" "commercial_finance_peering" {
#  name         = "commercial-finance-peering"
#  network      = google_compute_network.commercial_network.self_link
#  peer_network = google_compute_network.finance_network.self_link
#}
#
#resource "google_compute_network_peering" "finance_commercial_peering" {
#  name         = "finance-commercial-peering"
#  network      = google_compute_network.finance_network.self_link
#  peer_network = google_compute_network.commercial_network.self_link
#}

resource "google_compute_subnetwork" "commercial_subnetwork_europe_west9" {
  name                     = "commercial-europe-west9"
  ip_cidr_range            = "10.0.0.0/24"
  region                   = "europe-west9"
  network                  = google_compute_network.commercial_network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "commercial_subnetwork_europe_west3" {
  name                     = "commercial-europe-west3"
  ip_cidr_range            = "10.0.1.0/24"
  region                   = "europe-west9"
  network                  = google_compute_network.commercial_network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "commercial_subnetwork_us_east1" {
  name                     = "commercial-us-east1"
  ip_cidr_range            = "10.0.10.0/24"
  region                   = "us-east1"
  network                  = google_compute_network.commercial_network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "commercial_subnetwork_us_west1" {
  name                     = "commercial-us-west1"
  ip_cidr_range            = "10.0.11.0/24"
  region                   = "us-west1"
  network                  = google_compute_network.commercial_network.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "finance_subnetwork_asia_south1" {
  name                     = "finance-asia-south1"
  ip_cidr_range            = "192.168.0.0/24"
  region                   = "asia-south1"
  network                  = google_compute_network.finance_network.id
  private_ip_google_access = true
}


resource "google_compute_firewall" "commercial_icmp" {
  name    = "commercial-allow-icmp"
  network = google_compute_network.commercial_network.id

  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "commercial_ssh" {
  name    = "commercial-allow-ssh"
  network = google_compute_network.commercial_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "finance_icmp" {
  name    = "finance-allow-icmp"
  network = google_compute_network.finance_network.id

  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "finance_ssh" {
  name    = "finance-allow-ssh"
  network = google_compute_network.commercial_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
