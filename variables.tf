variable "organization_name" {
  description = "Name of the organization used across all cloud providers."
  type        = string
}

variable "aws_allowed_regions" {
  description = "List of AWS regions allowed by SCP."
  type        = list(string)
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable "aws_log_archive_email" {
  description = "Email address for the AWS Log Archive account."
  type        = string
}

variable "aws_audit_email" {
  description = "Email address for the AWS Audit account."
  type        = string
}

variable "enable_control_tower" {
  description = "Enable AWS Control Tower."
  type        = bool
  default     = true
}

variable "enable_cloudtrail" {
  description = "Enable organization-level CloudTrail."
  type        = bool
  default     = true
}

variable "cloudtrail_s3_bucket" {
  description = "S3 bucket name for CloudTrail logs."
  type        = string
  default     = ""
}

variable "enable_guardduty" {
  description = "Enable organization-level GuardDuty."
  type        = bool
  default     = true
}

variable "enable_security_hub" {
  description = "Enable organization-level Security Hub."
  type        = bool
  default     = true
}

variable "azure_allowed_locations" {
  description = "List of allowed Azure locations."
  type        = list(string)
  default     = ["eastus", "westus2", "westeurope"]
}

variable "azure_primary_location" {
  description = "Primary Azure location for management resources."
  type        = string
  default     = "eastus"
}

variable "azure_management_resource_group" {
  description = "Resource group for Azure management resources."
  type        = string
  default     = "rg-management"
}

variable "azure_log_retention_days" {
  description = "Azure log retention period in days."
  type        = number
  default     = 365
}

variable "enable_defender" {
  description = "Enable Microsoft Defender for Cloud."
  type        = bool
  default     = true
}

variable "gcp_org_id" {
  description = "GCP Organization ID."
  type        = string
}

variable "gcp_billing_account" {
  description = "GCP Billing Account ID."
  type        = string
}

variable "gcp_project_prefix" {
  description = "Prefix for GCP project names and IDs."
  type        = string
  default     = "org"
}

variable "gcp_allowed_regions" {
  description = "List of allowed GCP regions."
  type        = list(string)
  default     = ["us-central1", "us-east1", "europe-west1"]
}

variable "saml_provider_name" {
  description = "Name of the SAML provider for identity federation."
  type        = string
  default     = "EnterpriseIdP"
}

variable "saml_metadata_document" {
  description = "SAML metadata XML document from the IdP."
  type        = string
}

variable "gcp_workforce_pool_id" {
  description = "ID for the GCP Workforce Identity Pool."
  type        = string
  default     = "enterprise-pool"
}

variable "tags" {
  description = "Tags to apply to all AWS and Azure resources."
  type        = map(string)
  default     = {}
}

variable "gcp_labels" {
  description = "Labels to apply to all GCP resources."
  type        = map(string)
  default     = {}
}
