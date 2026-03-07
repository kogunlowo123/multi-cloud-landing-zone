###############################################################################
# Identity Federation Module
# Cross-cloud SSO and RBAC via SAML 2.0 / OIDC federation
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# -----------------------------------------------------------------------------
# AWS SAML Provider
# -----------------------------------------------------------------------------
resource "aws_iam_saml_provider" "enterprise_idp" {
  name                   = var.saml_provider_name
  saml_metadata_document = var.saml_metadata_document
}

# -----------------------------------------------------------------------------
# AWS IAM Roles for Federated Access
# -----------------------------------------------------------------------------
resource "aws_iam_role" "federated_admin" {
  name = "FederatedAdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_saml_provider.enterprise_idp.arn
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role" "federated_readonly" {
  name = "FederatedReadOnlyRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_saml_provider.enterprise_idp.arn
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "readonly_policy" {
  role       = aws_iam_role.federated_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# -----------------------------------------------------------------------------
# GCP Workload Identity Federation
# -----------------------------------------------------------------------------
resource "google_iam_workforce_pool" "enterprise" {
  workforce_pool_id = var.gcp_workforce_pool_id
  parent            = "organizations/${var.gcp_org_id}"
  location          = "global"
  display_name      = "Enterprise Identity Pool"
  description       = "Workforce identity pool for enterprise SSO"
}

resource "google_iam_workforce_pool_provider" "saml" {
  workforce_pool_id = google_iam_workforce_pool.enterprise.workforce_pool_id
  location          = "global"
  provider_id       = "enterprise-saml"
  display_name      = "Enterprise SAML Provider"

  saml {
    idp_metadata_xml = var.saml_metadata_document
  }
}
