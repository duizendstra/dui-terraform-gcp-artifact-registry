variable "project_id" {
  description = "The project ID to deploy resources into"
  type        = string
}

variable "region" {
  description = "The region in which to create the repositories"
  type        = string
  default     = "europe-west1"
}

variable "repositories" {
  description = "List of repositories to create"
  type = list(object({
    name        = string
    description = string
    format      = string
    accessors   = optional(map(list(object({
      member           = string
      member_type      = string
      transform_member = bool
      project_id       = string
      project_number   = string
    }))), {})
  }))
  default = []
}
