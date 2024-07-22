terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.38.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.38.0"
    }
  }
}

module "artifact_registry" {
  source     = "./.."
  project_id = "your-project-id"
  repositories = [
    {
      name        = "repository-name"
      description = "Repository description"
      format      = "DOCKER"
      accessors = {
        "roles/artifactregistry.reader" = [
          {
            member           = "user@example.com"
            member_type      = "user"
            transform_member = false
            project_id       = ""
            project_number   = ""
          }
        ]
      }
    }
  ]
}
