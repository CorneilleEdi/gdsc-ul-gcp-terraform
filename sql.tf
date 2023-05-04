#variable "audit_db_username" {
#  default = "john.doe"
#}
#
#resource "random_id" "audit_db_user_password" {
#  byte_length = 8
#}

#resource "google_sql_database_instance" "audit" {
#  name             = "audit-instance"
#  database_version = "POSTGRES_14"
#  region           = "europe-west9"
#  deletion_protection = false
#
#  settings {
#    tier              = "db-custom-1-4096"
#    disk_size         = 10
#    disk_type         = "PD_SSD"
#    pricing_plan      = "PER_USE"
#    availability_type = "ZONAL"
#  }
#
#  timeouts {
#    create = "20m"
#    update = "20m"
#    delete = "20m"
#  }
#}

#resource "google_sql_database" "audit_countries" {
#  name     = "audit-countries"
#  instance = google_sql_database_instance.audit.name
#}
#
#resource "google_sql_user" "default" {
#  name     = var.audit_db_username
#  project  = var.project_id
#  instance = google_sql_database_instance.audit.name
#  password = random_id.audit_db_user_password.hex
#}