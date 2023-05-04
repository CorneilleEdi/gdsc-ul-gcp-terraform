data "archive_file" "scheduled_vms_deletion" {
  type        = "zip"
  source_dir  = "${path.module}/sources/scheduled-vms-deletion"
  output_path = "${path.module}/scheduled-vms-deletion.zip"
}

resource "google_storage_bucket_object" "scheduled_vms_deletion" {
  name         = "scheduled-vms-deletion.zip"
  bucket       = google_storage_bucket.exec.name
  source       = "${path.module}/scheduled-vms-deletion.zip"
  content_type = "application/zip"
}

resource "google_cloudfunctions_function" "scheduled-vms-deletion" {
  name        = "scheduled-vms-deletion"
  description = "Scheduled VMs deletion called by Cloud Scheduler"
  runtime     = "python39"
  region      = "europe-west3"

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.exec.name
  source_archive_object = google_storage_bucket_object.scheduled_vms_deletion.name
  trigger_http          = true
  entry_point           = "handler"
  timeout               = 300
  max_instances         = 1

  labels = var.labels
}

# --------------------- GCE INSTANCE FUNCTION ---------------------
data "archive_file" "gce_instance_events" {
  type        = "zip"
  source_dir  = "${path.module}/sources/assets-gce-events"
  output_path = "${path.module}/assets-gce-events.zip"
}


resource "google_storage_bucket_object" "gce_instance_events" {
  name         = "gce-instance-event.zip"
  bucket       = google_storage_bucket.exec.name
  source       = data.archive_file.gce_instance_events.output_path
  content_type = "application/zip"
}

resource "google_cloudfunctions_function" "gce_instance_events" {
  name        = "gce-instance-event"
  description = "GCE Instance event called by Cloud Pub/Sub"
  runtime     = "python39"
  region      = "europe-west3"

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.exec.name
  source_archive_object = google_storage_bucket_object.gce_instance_events.name

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.gce_instance_feed.name
  }
  entry_point   = "handler"
  timeout       = 300
  max_instances = 1

  environment_variables = {
    GCP_PROJECT = var.project_id
  }
  labels = var.labels
}