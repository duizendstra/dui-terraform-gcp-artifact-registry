terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.32.0"
    }
  }
}
resource "google_artifact_registry_repository" "repositories" {
  for_each = { for repo in var.repositories : repo.name => repo }

  project       = var.project_id
  location      = var.region
  repository_id = each.key
  format        = each.value.format
  description   = each.value.description
}


locals {
  transformed_artifact_accessors = flatten([
    for repository in var.repositories : [
      for role, members in repository.accessors : [
        for member_config in members : {
          repository = repository.name
          role       = role
          member     = (
            member_config.transform_member && member_config.member_type == "serviceAgent" ? 
            "serviceAccount:service-${coalesce(member_config.project_number, member_config.project_number)}@gcp-sa-${member_config.member}.iam.gserviceaccount.com" :
            member_config.transform_member && member_config.member_type == "serviceAccount" ? 
            "serviceAccount:${member_config.member}@${coalesce(member_config.project_id, member_config.project_id)}.iam.gserviceaccount.com" :
            "${member_config.member_type}:${member_config.member}"
          )
        }
      ]
    ]
  ])
}

resource "google_artifact_registry_repository_iam_member" "access_repository" {
  for_each = { for accessor in local.transformed_artifact_accessors : "${accessor.repository}:${accessor.member}" => accessor }

  repository = google_artifact_registry_repository.repositories[each.value.repository].id
  role       = each.value.role
  member     = each.value.member
}

