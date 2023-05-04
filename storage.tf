resource "google_storage_bucket" "exec" {
  name          = "exec-assets-bucket-${var.project_id}"
  location      = "EU"
  storage_class = "STANDARD"
  force_destroy = true
  labels        = var.labels
}