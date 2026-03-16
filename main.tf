module "aws_landing_zone" {
  source = "./modules/aws-landing-zone"

  organization_name    = var.organization_name
  allowed_regions      = var.aws_allowed_regions
  log_archive_email    = var.aws_log_archive_email
  audit_email          = var.aws_audit_email
  enable_control_tower = var.enable_control_tower
  enable_cloudtrail    = var.enable_cloudtrail
  cloudtrail_s3_bucket = var.cloudtrail_s3_bucket
  enable_guardduty     = var.enable_guardduty
  enable_security_hub  = var.enable_security_hub
  tags                 = var.tags
}

module "azure_landing_zone" {
  source = "./modules/azure-landing-zone"

  root_management_group_name = var.organization_name
  allowed_locations          = var.azure_allowed_locations
  primary_location           = var.azure_primary_location
  management_resource_group  = var.azure_management_resource_group
  log_retention_days         = var.azure_log_retention_days
  enable_defender            = var.enable_defender
  tags                       = var.tags
}

module "gcp_landing_zone" {
  source = "./modules/gcp-landing-zone"

  org_id          = var.gcp_org_id
  billing_account = var.gcp_billing_account
  project_prefix  = var.gcp_project_prefix
  allowed_regions = var.gcp_allowed_regions
  labels          = var.gcp_labels
}

module "identity_federation" {
  source = "./modules/identity-federation"

  saml_provider_name     = var.saml_provider_name
  saml_metadata_document = var.saml_metadata_document
  gcp_org_id             = var.gcp_org_id
  gcp_workforce_pool_id  = var.gcp_workforce_pool_id
  tags                   = var.tags
}
