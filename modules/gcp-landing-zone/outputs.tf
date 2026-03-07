output "org_id" {
  description = "The GCP Organization ID"
  value       = var.org_id
}

output "bootstrap_folder_id" {
  description = "The ID of the Bootstrap folder"
  value       = google_folder.bootstrap.id
}

output "common_folder_id" {
  description = "The ID of the Common folder"
  value       = google_folder.common.id
}

output "production_folder_id" {
  description = "The ID of the Production folder"
  value       = google_folder.production.id
}

output "seed_project_id" {
  description = "The project ID of the seed project"
  value       = google_project.seed.project_id
}

output "logging_project_id" {
  description = "The project ID of the logging project"
  value       = google_project.logging.project_id
}

output "networking_project_id" {
  description = "The project ID of the networking project"
  value       = google_project.networking.project_id
}

output "security_project_id" {
  description = "The project ID of the security project"
  value       = google_project.security.project_id
}
