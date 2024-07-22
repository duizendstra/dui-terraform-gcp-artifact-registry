output "repository_urls" {
  value = [for repo in google_artifact_registry_repository.repositories : repo.id]
}