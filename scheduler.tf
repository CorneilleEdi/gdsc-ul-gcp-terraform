data "google_compute_default_service_account" "default" {
}

resource "google_cloud_scheduler_job" "vm_cleaning_job" {
  name             = "vm-cleaning-job"
  description      = "Cleans up VMs. Stop all terraform VMs and delete all VMs that are not in use."
  schedule         = "0 */4 * * *"
  time_zone        = "Europe/Paris"
  attempt_deadline = "320s"
  region           = "europe-west3"

  http_target {
    http_method = "GET"
    uri         = google_cloudfunctions_function.scheduled-vms-deletion.https_trigger_url

    oidc_token {
      service_account_email = google_service_account.function_invoker.email
    }
  }
}