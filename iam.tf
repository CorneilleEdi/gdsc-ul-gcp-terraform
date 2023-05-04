locals {

  role_conditions = {
    "viewer"                = []
    "compute.instanceAdmin" = [
      {
        title       = "limited_to_20_to_00"
        description = "Limited to 20h to 00h GMT"
        expression  = "request.time.getHours(\"Europe/Berlin\") >= 22 && request.time.getHours(\"Europe/Berlin\") <= 1"
        #   expression = "request.time.getHours(\"Europe/Paris\") >= 18 && request.time.getHours(\"Europe/Paris\") <= 20 && request.time.getDayOfWeek(\"Europe/Berlin\") >= 0 && request.time.getDayOfWeek(\"Europe/Berlin\") <= 6"
      }
    ],
    "storage.admin" = [
      #      {
      #        title       = "lab_bucket_access"
      #        description = "Limited to lab bucket access"
      #        expression  = "resource.name.startsWith(\"lab-\")"
      #        #   expression = "request.time.getHours(\"Europe/Paris\") >= 18 && request.time.getHours(\"Europe/Paris\") <= 20 && request.time.getDayOfWeek(\"Europe/Berlin\") >= 0 && request.time.getDayOfWeek(\"Europe/Berlin\") <= 6"
      #      }
    ]
  }


  users_roles = {
    "XXX@gmail.com" = ["viewer", "compute.instanceAdmin", "storage.admin"],
  }

  storage_roles = [
    "roles/storage.buckets.create",
    "roles/storage.buckets.delete",
    "roles/storage.buckets.get",
    "roles/storage.buckets.list",
    "roles/storage.buckets.update",
    "roles/storage.objects.setIamPolicy"
  ]
}


resource "google_project_iam_binding" "role_conditions" {
  project  = var.project_id
  for_each = {for role, conditions in local.role_conditions : role => conditions}

  role    = "roles/${each.key}"
  members = [for email, roles in local.users_roles : "user:${email}" if contains(roles, each.key)]

  dynamic "condition" {
    for_each = each.value
    content {
      title       = condition.value.title
      description = condition.value.description
      expression  = condition.value.expression
    }
  }
}

#resource "google_project_iam_custom_role" "storage_user" {
#  role_id     = "storageUser"
#  title       = "Storage User"
#  description = "A simple custom role for storage user"
#  permissions = [
#    "storage.buckets.create",
#    "storage.buckets.delete",
#    "storage.buckets.get",
#    "storage.buckets.list",
#    "storage.buckets.update",
#    "storage.objects.setIamPolicy",
#    "storage.objects.create",
#    "storage.objects.delete",
#    "storage.objects.get",
#    "storage.objects.getIamPolicy",
#    "storage.objects.list",
#    "storage.objects.setIamPolicy",
#    "storage.objects.update",
#    "storage.multipartUploads.create",
#    "storage.multipartUploads.abort",
#    "storage.multipartUploads.listParts",
#    "storage.multipartUploads.list"
#  ]
#}
#
#resource "google_project_iam_custom_role" "storage_user_access_manager" {
#  role_id     = "storageUserAccessManager"
#  title       = "Storage User Access Manager"
#  description = "A simple custom role for storage user access manager"
#  permissions = [
#    "storage.buckets.getIamPolicy",
#    "storage.buckets.setIamPolicy",
#    "storage.objects.setIamPolicy",
#    "storage.objects.getIamPolicy"
#  ]
#
#
#}
#
#resource "google_project_iam_binding" "storage_user" {
#  project = var.project_id
#  role    = google_project_iam_custom_role.storage_user.id
#
#  members = ["user:XXX@gmail.com"]
#}
#
#resource "google_project_iam_binding" "storage_user_access_manager" {
#  project = var.project_id
#  role    = google_project_iam_custom_role.storage_user_access_manager.id
#
#  members = ["user:XXX@gmail.com"]
#}

resource "google_service_account" "function_invoker" {
  account_id   = "function-invoker"
  display_name = "Function invoker"
}

resource "google_project_iam_binding" "cloudfunctions_invoker_binding" {
  project = var.project_id
  role    = "roles/cloudfunctions.invoker"

  members = [
    "serviceAccount:${google_service_account.function_invoker.email}"
  ]
}