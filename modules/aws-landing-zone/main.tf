###############################################################################
# AWS Landing Zone Module
# Provisions AWS Organization, SCPs, Control Tower, and core security services
###############################################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -----------------------------------------------------------------------------
# AWS Organization
# -----------------------------------------------------------------------------
resource "aws_organizations_organization" "this" {
  feature_set = "ALL"

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY",
  ]

  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com",
    "sso.amazonaws.com",
  ]
}

# -----------------------------------------------------------------------------
# Organizational Units
# -----------------------------------------------------------------------------
resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "Infrastructure"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = aws_organizations_organization.this.roots[0].id
}

# -----------------------------------------------------------------------------
# Service Control Policies
# -----------------------------------------------------------------------------
resource "aws_organizations_policy" "deny_regions" {
  name        = "DenyUnallowedRegions"
  description = "Deny access to regions not in the allowed list"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyUnallowedRegions"
        Effect    = "Deny"
        Action    = "*"
        Resource  = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = var.allowed_regions
          }
        }
      }
    ]
  })
}

resource "aws_organizations_policy" "deny_root_user" {
  name        = "DenyRootUser"
  description = "Deny all actions by the root user"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyRootUser"
        Effect    = "Deny"
        Action    = "*"
        Resource  = "*"
        Condition = {
          StringLike = {
            "aws:PrincipalArn" = "arn:aws:iam::*:root"
          }
        }
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# Log Archive Account
# -----------------------------------------------------------------------------
resource "aws_organizations_account" "log_archive" {
  name      = "${var.organization_name}-log-archive"
  email     = var.log_archive_email
  parent_id = aws_organizations_organizational_unit.security.id

  tags = merge(var.tags, {
    Purpose = "LogArchive"
  })

  lifecycle {
    ignore_changes = [email]
  }
}

# -----------------------------------------------------------------------------
# Audit Account
# -----------------------------------------------------------------------------
resource "aws_organizations_account" "audit" {
  name      = "${var.organization_name}-audit"
  email     = var.audit_email
  parent_id = aws_organizations_organizational_unit.security.id

  tags = merge(var.tags, {
    Purpose = "Audit"
  })

  lifecycle {
    ignore_changes = [email]
  }
}

# -----------------------------------------------------------------------------
# CloudTrail (Organization-level)
# -----------------------------------------------------------------------------
resource "aws_cloudtrail" "organization" {
  count = var.enable_cloudtrail ? 1 : 0

  name                       = "${var.organization_name}-org-trail"
  s3_bucket_name             = var.cloudtrail_s3_bucket
  is_organization_trail      = true
  is_multi_region_trail      = true
  enable_log_file_validation = true

  tags = var.tags
}

# -----------------------------------------------------------------------------
# GuardDuty (Organization-level)
# -----------------------------------------------------------------------------
resource "aws_guardduty_organization_admin_account" "this" {
  count = var.enable_guardduty ? 1 : 0

  admin_account_id = aws_organizations_account.audit.id
}

# -----------------------------------------------------------------------------
# Security Hub (Organization-level)
# -----------------------------------------------------------------------------
resource "aws_securityhub_organization_admin_account" "this" {
  count = var.enable_security_hub ? 1 : 0

  admin_account_id = aws_organizations_account.audit.id
}
