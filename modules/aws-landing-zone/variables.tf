variable "organization_name" {
  description = "Name of the AWS Organization"
  type        = string
}

variable "allowed_regions" {
  description = "List of AWS regions allowed by SCP"
  type        = list(string)
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable "log_archive_email" {
  description = "Email address for the Log Archive account"
  type        = string
  default     = "log-archive@example.com"
}

variable "audit_email" {
  description = "Email address for the Audit account"
  type        = string
  default     = "audit@example.com"
}

variable "enable_control_tower" {
  description = "Enable AWS Control Tower"
  type        = bool
  default     = true
}

variable "enable_cloudtrail" {
  description = "Enable organization-level CloudTrail"
  type        = bool
  default     = true
}

variable "cloudtrail_s3_bucket" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
  default     = ""
}

variable "enable_guardduty" {
  description = "Enable organization-level GuardDuty"
  type        = bool
  default     = true
}

variable "enable_security_hub" {
  description = "Enable organization-level Security Hub"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Project   = "multi-cloud-landing-zone"
  }
}
