variable "root_management_group_name" {
  description = "Display name for the root management group"
  type        = string
}

variable "allowed_locations" {
  description = "List of allowed Azure locations"
  type        = list(string)
  default     = ["eastus", "westus2", "westeurope"]
}

variable "enable_defender" {
  description = "Enable Microsoft Defender for Cloud"
  type        = bool
  default     = true
}

variable "primary_location" {
  description = "Primary Azure location for management resources"
  type        = string
  default     = "eastus"
}

variable "management_resource_group" {
  description = "Resource group for management resources"
  type        = string
  default     = "rg-management"
}

variable "log_retention_days" {
  description = "Log retention period in days"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    ManagedBy = "terraform"
    Project   = "multi-cloud-landing-zone"
  }
}
