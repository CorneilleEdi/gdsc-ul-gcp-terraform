variable "project_id" {
  default     = "gdsc-ul-playground-eros"
  description = "The project ID to deploy to"
}

variable "region" {
  default     = "europe-west9"
  description = "The region to deploy to"
}

variable "zone" {
  default     = "europe-west9-a"
  description = "The zone to deploy to"
}

variable "labels" {
  type = map(string)
  default = {
    "owner" = "terraform"
  }
  description = "Labels to apply to all resources"
}