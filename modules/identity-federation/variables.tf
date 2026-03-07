variable "saml_provider_name" {
  description = "Name of the SAML provider"
  type        = string
  default     = "EnterpriseIdP"
}

variable "saml_metadata_document" {
  description = "SAML metadata XML document from the IdP"
  type        = string
}

variable "idp_metadata_url" {
  description = "URL of the IdP metadata endpoint"
  type        = string
  default     = ""
}

variable "aws_sso_arn" {
  description = "ARN of the AWS SSO instance"
  type        = string
  default     = ""
}

variable "gcp_org_id" {
  description = "GCP Organization ID for workforce identity federation"
  type        = string
}

variable "gcp_workforce_pool_id" {
  description = "ID for the GCP Workforce Identity Pool"
  type        = string
  default     = "enterprise-pool"
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Project   = "multi-cloud-landing-zone"
  }
}
