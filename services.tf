## enable GCP APIs
locals {
  services = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudbuild.googleapis.com",
    "dns.googleapis.com",
    "pubsub.googleapis.com",
    "secretmanager.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "redis.googleapis.com",
    "firestore.googleapis.com",
    "servicecontrol.googleapis.com",
    "apigateway.googleapis.com",
    "workflows.googleapis.com",
    "run.googleapis.com",
    "cloudkms.googleapis.com",
    "networkmanagement.googleapis.com",
  ]
}

resource "google_project_service" "this" {
  project  = var.project_id
  for_each = toset(local.services)
  service  = each.value
  disable_on_destroy = false
}