resource "google_cloud_asset_project_feed" "compute_engine_feed" {
  project      = var.project_id
  feed_id      = "gce-instance-feed-feed"
  content_type = "RESOURCE"

  asset_types = [
    "compute.googleapis.com/Instance"
  ]

  feed_output_config {
    pubsub_destination {
      topic = google_pubsub_topic.gce_instance_feed.id
    }
  }

  condition {
    expression  = <<-EOT
    !temporal_asset.deleted &&
    temporal_asset.prior_asset_state == google.cloud.asset.v1.TemporalAsset.PriorAssetState.DOES_NOT_EXIST
    EOT
    title       = "created"
    description = "Send notifications on creation events"
  }
  depends_on = [
    google_pubsub_topic.gce_instance_feed,
    google_pubsub_subscription.gce_instance_feed
  ]
}

resource "google_pubsub_topic" "gce_instance_feed" {
  name = "gce-instance-feed-topic"
}

resource "google_pubsub_subscription" "gce_instance_feed" {
  name  = "gce-instance-feed-subscription"
  topic = google_pubsub_topic.gce_instance_feed.name
}