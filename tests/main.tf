###############################################################################
# Test Fixture - Multi-Cloud Landing Zone
# Calls all submodules with realistic values for validation and testing
###############################################################################

# -----------------------------------------------------------------------------
# AWS Landing Zone
# -----------------------------------------------------------------------------
module "aws_landing_zone" {
  source = "../modules/aws-landing-zone"

  organization_name = "acme-corp"
  allowed_regions   = ["us-east-1", "us-west-2", "eu-west-1"]
  log_archive_email = "log-archive@acme-corp.com"
  audit_email       = "security-audit@acme-corp.com"

  enable_control_tower = true
  enable_cloudtrail    = true
  cloudtrail_s3_bucket = "acme-corp-org-cloudtrail-logs"
  enable_guardduty     = true
  enable_security_hub  = true

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "multi-cloud-landing-zone"
    CostCenter  = "platform-engineering"
  }
}

# -----------------------------------------------------------------------------
# Azure Landing Zone
# -----------------------------------------------------------------------------
module "azure_landing_zone" {
  source = "../modules/azure-landing-zone"

  root_management_group_name = "acme-corp"
  allowed_locations          = ["eastus", "westus2", "westeurope"]
  primary_location           = "eastus"
  management_resource_group  = "rg-acme-management"
  log_retention_days         = 365
  enable_defender            = true

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "multi-cloud-landing-zone"
    CostCenter  = "platform-engineering"
  }
}

# -----------------------------------------------------------------------------
# GCP Landing Zone
# -----------------------------------------------------------------------------
module "gcp_landing_zone" {
  source = "../modules/gcp-landing-zone"

  org_id          = "123456789012"
  billing_account = "01ABCD-234EFG-567HIJ"
  project_prefix  = "acme"
  allowed_regions = ["us-central1", "us-east1", "europe-west1"]

  labels = {
    environment = "test"
    managed_by  = "terraform"
    project     = "multi-cloud-landing-zone"
    cost_center = "platform-engineering"
  }
}

# -----------------------------------------------------------------------------
# Identity Federation
# -----------------------------------------------------------------------------
module "identity_federation" {
  source = "../modules/identity-federation"

  saml_provider_name = "AcmeCorpIdP"
  saml_metadata_document = <<-XML
    <EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata"
                      entityID="https://idp.acme-corp.com/saml/metadata">
      <IDPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
        <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"
                             Location="https://idp.acme-corp.com/saml/sso"/>
      </IDPSSODescriptor>
    </EntityDescriptor>
  XML

  idp_metadata_url      = "https://idp.acme-corp.com/saml/metadata"
  aws_sso_arn           = "arn:aws:sso:::instance/ssoins-1234567890abcdef"
  gcp_org_id            = "123456789012"
  gcp_workforce_pool_id = "acme-enterprise-pool"

  tags = {
    Environment = "test"
    ManagedBy   = "terraform"
    Project     = "multi-cloud-landing-zone"
    CostCenter  = "platform-engineering"
  }
}
