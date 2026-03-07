output "aws_saml_provider_arn" {
  description = "ARN of the AWS SAML provider"
  value       = aws_iam_saml_provider.enterprise_idp.arn
}

output "federated_admin_role_arn" {
  description = "ARN of the federated admin IAM role"
  value       = aws_iam_role.federated_admin.arn
}

output "federated_readonly_role_arn" {
  description = "ARN of the federated read-only IAM role"
  value       = aws_iam_role.federated_readonly.arn
}

output "gcp_workforce_pool_id" {
  description = "The ID of the GCP Workforce Identity Pool"
  value       = google_iam_workforce_pool.enterprise.id
}
