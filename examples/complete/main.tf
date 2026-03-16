module "aws_landing_zone" {
  source = "../../modules/aws-landing-zone"

  organization_name    = var.organization_name
  allowed_regions      = ["us-east-1", "us-west-2", "eu-west-1"]
  log_archive_email    = "aws-log-archive@acme-corp.com"
  audit_email          = "aws-security-audit@acme-corp.com"
  enable_control_tower = true
  enable_cloudtrail    = true
  cloudtrail_s3_bucket = "${var.organization_name}-org-cloudtrail-logs"
  enable_guardduty     = true
  enable_security_hub  = true
  tags                 = var.tags
}

module "azure_landing_zone" {
  source = "../../modules/azure-landing-zone"

  root_management_group_name = var.organization_name
  allowed_locations          = ["eastus", "westus2", "westeurope", "northeurope"]
  primary_location           = "eastus"
  management_resource_group  = "rg-${var.organization_name}-management"
  log_retention_days         = 730
  enable_defender            = true
  tags                       = var.tags
}

module "gcp_landing_zone" {
  source = "../../modules/gcp-landing-zone"

  org_id          = "123456789012"
  billing_account = "01ABCD-234EFG-567HIJ"
  project_prefix  = var.organization_name
  allowed_regions = ["us-central1", "us-east1", "europe-west1", "europe-west4"]

  labels = {
    environment = "production"
    managed_by  = "terraform"
    project     = "multi-cloud-landing-zone"
    cost_center = "platform-engineering"
    owner       = "cloud-platform-team"
  }
}

module "identity_federation" {
  source = "../../modules/identity-federation"

  saml_provider_name     = "AcmeCorpEnterpriseIdP"
  saml_metadata_document = file("${path.module}/saml-metadata.xml")
  idp_metadata_url       = "https://login.acme-corp.com/federationmetadata/saml20/metadata"
  aws_sso_arn            = module.aws_landing_zone.sso_instance_arn
  gcp_org_id             = "123456789012"
  gcp_workforce_pool_id  = "${var.organization_name}-enterprise-pool"
  tags                   = var.tags
}

variable "organization_name" {
  description = "Name of the organization."
  type        = string
  default     = "acme-corp"
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = "multi-cloud-landing-zone"
    CostCenter  = "platform-engineering"
    Owner       = "cloud-platform-team"
  }
}
