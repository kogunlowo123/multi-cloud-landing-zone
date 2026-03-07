variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account" {
  description = "GCP Billing Account ID"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for project names and IDs"
  type        = string
  default     = "org"
}

variable "allowed_regions" {
  description = "List of allowed GCP regions"
  type        = list(string)
  default     = ["us-central1", "us-east1", "europe-west1"]
}

variable "labels" {
  description = "Default labels for all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    project    = "multi-cloud-landing-zone"
  }
}
