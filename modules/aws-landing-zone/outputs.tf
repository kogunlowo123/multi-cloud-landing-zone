output "organization_id" {
  description = "The ID of the AWS Organization"
  value       = aws_organizations_organization.this.id
}

output "organization_arn" {
  description = "The ARN of the AWS Organization"
  value       = aws_organizations_organization.this.arn
}

output "security_ou_id" {
  description = "The ID of the Security OU"
  value       = aws_organizations_organizational_unit.security.id
}

output "infrastructure_ou_id" {
  description = "The ID of the Infrastructure OU"
  value       = aws_organizations_organizational_unit.infrastructure.id
}

output "workloads_ou_id" {
  description = "The ID of the Workloads OU"
  value       = aws_organizations_organizational_unit.workloads.id
}

output "log_archive_account_id" {
  description = "The account ID of the Log Archive account"
  value       = aws_organizations_account.log_archive.id
}

output "audit_account_id" {
  description = "The account ID of the Audit account"
  value       = aws_organizations_account.audit.id
}

output "sso_instance_arn" {
  description = "The ARN of the SSO instance"
  value       = aws_organizations_organization.this.arn
}
