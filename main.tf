terraform {
  required_version = ">= 1.3.5"
  backend "gcs" {
    bucket = "tf-state-gdsc-ul-playground-eros"
    prefix = "base"
  }
}

