###############################################################################
# Outputs - Complete Multi-Cloud Landing Zone
###############################################################################

# --- AWS ---

output "aws_organization_id" {
  description = "The ID of the AWS Organization"
  value       = module.aws_landing_zone.organization_id
}

output "aws_organization_arn" {
  description = "The ARN of the AWS Organization"
  value       = module.aws_landing_zone.organization_arn
}

output "aws_security_ou_id" {
  description = "The ID of the AWS Security OU"
  value       = module.aws_landing_zone.security_ou_id
}

output "aws_infrastructure_ou_id" {
  description = "The ID of the AWS Infrastructure OU"
  value       = module.aws_landing_zone.infrastructure_ou_id
}

output "aws_workloads_ou_id" {
  description = "The ID of the AWS Workloads OU"
  value       = module.aws_landing_zone.workloads_ou_id
}

output "aws_log_archive_account_id" {
  description = "The account ID of the AWS Log Archive account"
  value       = module.aws_landing_zone.log_archive_account_id
}

output "aws_audit_account_id" {
  description = "The account ID of the AWS Audit account"
  value       = module.aws_landing_zone.audit_account_id
}

# --- Azure ---

output "azure_root_management_group_id" {
  description = "The ID of the Azure root management group"
  value       = module.azure_landing_zone.root_management_group_id
}

output "azure_platform_management_group_id" {
  description = "The ID of the Azure Platform management group"
  value       = module.azure_landing_zone.platform_management_group_id
}

output "azure_landing_zones_management_group_id" {
  description = "The ID of the Azure Landing Zones management group"
  value       = module.azure_landing_zone.landing_zones_management_group_id
}

output "azure_log_analytics_workspace_id" {
  description = "The ID of the Azure central Log Analytics workspace"
  value       = module.azure_landing_zone.log_analytics_workspace_id
}

# --- GCP ---

output "gcp_bootstrap_folder_id" {
  description = "The ID of the GCP Bootstrap folder"
  value       = module.gcp_landing_zone.bootstrap_folder_id
}

output "gcp_common_folder_id" {
  description = "The ID of the GCP Common folder"
  value       = module.gcp_landing_zone.common_folder_id
}

output "gcp_production_folder_id" {
  description = "The ID of the GCP Production folder"
  value       = module.gcp_landing_zone.production_folder_id
}

output "gcp_seed_project_id" {
  description = "The project ID of the GCP seed project"
  value       = module.gcp_landing_zone.seed_project_id
}

output "gcp_logging_project_id" {
  description = "The project ID of the GCP logging project"
  value       = module.gcp_landing_zone.logging_project_id
}

output "gcp_networking_project_id" {
  description = "The project ID of the GCP networking project"
  value       = module.gcp_landing_zone.networking_project_id
}

output "gcp_security_project_id" {
  description = "The project ID of the GCP security project"
  value       = module.gcp_landing_zone.security_project_id
}

# --- Identity Federation ---

output "aws_saml_provider_arn" {
  description = "ARN of the AWS SAML provider"
  value       = module.identity_federation.aws_saml_provider_arn
}

output "federated_admin_role_arn" {
  description = "ARN of the federated admin IAM role"
  value       = module.identity_federation.federated_admin_role_arn
}

output "federated_readonly_role_arn" {
  description = "ARN of the federated read-only IAM role"
  value       = module.identity_federation.federated_readonly_role_arn
}

output "gcp_workforce_pool_id" {
  description = "The ID of the GCP Workforce Identity Pool"
  value       = module.identity_federation.gcp_workforce_pool_id
}
