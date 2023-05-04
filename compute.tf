locals {
  vms = {
    "operation" : {
      name   = "operation-us-east-1-b"
      region = "us-east1"
      zone   = "us-east1-b"
      subnet = google_compute_subnetwork.commercial_subnetwork_us_east1.self_link,
    },
    "support" : {
      name   = "support-us-east-1-c"
      region = "us-east1"
      zone   = "us-east1-c"
      subnet = google_compute_subnetwork.commercial_subnetwork_us_east1.self_link
    },
    "development" : {
      name   = "development-us-west-1-c"
      region = "us-west1"
      zone   = "us-west1-c"
      subnet = google_compute_subnetwork.commercial_subnetwork_us_west1.self_link
    },
    "audit" : {
      name   = "audit-europe-west9-c"
      region = "europe-west9"
      zone   = "europe-west9-c"
      subnet = google_compute_subnetwork.commercial_subnetwork_europe_west9.self_link
    }
    "finance-analytic" : {
      name   = "finance-analytic-asia-south1-a"
      region = "asia-south1"
      zone   = "asia-south1-a"
      subnet = google_compute_subnetwork.finance_subnetwork_asia_south1.self_link
    }
  }
}

resource "google_compute_address" "this" {
  for_each     = local.vms
  name         = "${each.value["name"]}-private-ip"
  address_type = "INTERNAL"
  subnetwork   = each.value["subnet"]
  region       = each.value["region"]
}


resource "google_compute_instance" "this" {
  for_each     = local.vms
  machine_type = "e2-micro"
  name         = each.value["name"]
  zone         = each.value["zone"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = each.value["subnet"]
    network_ip = google_compute_address.this[each.key].address
    access_config {
    }
  }
  labels = var.labels
}