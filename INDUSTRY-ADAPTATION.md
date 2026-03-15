# Industry Adaptation Guide

## Overview
The `multi-cloud-landing-zone` module provisions enterprise landing zones across AWS, Azure, and GCP with centralized identity federation (SAML/OIDC), organization-level security services (CloudTrail, GuardDuty, Security Hub on AWS; Defender and management groups on Azure; organization policies on GCP), and region-restriction policies. It provides the governance foundation for multi-cloud deployments in any regulated industry.

## Healthcare
### Compliance Requirements
- HIPAA, HITRUST, HL7 FHIR
### Configuration Changes
- **AWS**: Set `enable_cloudtrail = true`, `enable_guardduty = true`, and `enable_security_hub = true` for PHI environment monitoring. Restrict `allowed_regions` to regions with HIPAA BAA coverage.
- **Azure**: Set `enable_defender = true` and `log_retention_days = 365` for HIPAA audit trail requirements. Restrict `allowed_locations` to HIPAA-eligible regions.
- **GCP**: Restrict `allowed_regions` to HIPAA-covered regions.
- **Identity**: Configure `saml_metadata_document` from the organization's healthcare IdP. Use `gcp_workforce_pool_id` for federated identity across clouds.
- Apply `tags`/`labels` with `data-classification: phi` and `compliance: hipaa` across all three clouds.
### Example Use Case
A health system deploys a multi-cloud landing zone with HIPAA-restricted regions on all three providers, federated SAML authentication from their Okta instance, CloudTrail and Defender monitoring, and 365-day log retention across all clouds.

## Finance
### Compliance Requirements
- SOX, PCI-DSS, SOC 2
### Configuration Changes
- **AWS**: Set `enable_security_hub = true` with PCI-DSS standards, `enable_guardduty = true`, and provide `cloudtrail_s3_bucket` for long-term audit log archival (SOX).
- **Azure**: Set `enable_defender = true`, `log_retention_days = 365`, and configure management groups separating PCI and non-PCI subscriptions via `root_management_group_name`.
- **GCP**: Restrict `allowed_regions` to regions supporting data residency requirements.
- **Identity**: Configure `saml_metadata_document` with MFA-enforced IdP. Set `aws_sso_arn` for centralized AWS access management.
- Restrict `allowed_regions`/`allowed_locations` to approved financial regulatory jurisdictions.
### Example Use Case
A bank deploys landing zones in AWS, Azure, and GCP with region restrictions matching regulatory requirements, PCI-DSS Security Hub checks on AWS, Defender on Azure, SAML federation from Azure AD with MFA enforcement, and 365-day log retention.

## Government
### Compliance Requirements
- FedRAMP, CMMC, NIST 800-53
### Configuration Changes
- **AWS**: Deploy in GovCloud. Set `enable_control_tower = true`, `enable_cloudtrail = true`, `enable_guardduty = true`, `enable_security_hub = true`. Restrict `allowed_regions` to GovCloud regions.
- **Azure**: Deploy in Azure Government. Set `enable_defender = true`, `primary_location` to a government region, `log_retention_days = 365`.
- **GCP**: Deploy in Assured Workloads. Restrict `allowed_regions` to US regions.
- **Identity**: Configure `saml_metadata_document` from PIV/CAC-integrated IdP. Set `saml_provider_name` to match the government IdP.
- Apply `tags` with `impact-level`, `system-owner`, and `nist-controls` metadata.
### Example Use Case
A defense contractor deploys landing zones in AWS GovCloud, Azure Government, and GCP Assured Workloads with PIV-authenticated SAML federation, region restrictions to US-only, full audit logging with 365-day retention, and NIST 800-53-mapped Security Hub checks.

## Retail / E-Commerce
### Compliance Requirements
- PCI-DSS, CCPA/GDPR
### Configuration Changes
- **AWS**: Set `enable_guardduty = true` and `enable_security_hub = true` with PCI-DSS standards. Configure `allowed_regions` based on customer data residency (US, EU).
- **Azure**: Set `enable_defender = true` and configure `allowed_locations` for data residency compliance.
- **GCP**: Configure `allowed_regions` matching GDPR data residency requirements for EU customers.
- **Identity**: Configure `saml_metadata_document` for single sign-on across all cloud environments.
- Apply `tags` with `data-residency`, `pci-scope`, and `environment` labels.
### Example Use Case
A global retailer deploys landing zones with US and EU region restrictions for data residency, SAML federation for unified DevOps access, PCI-DSS Security Hub checks on AWS, and Defender on Azure for centralized security posture management.

## Education
### Compliance Requirements
- FERPA, COPPA
### Configuration Changes
- **AWS**: Set `enable_cloudtrail = true` and `enable_guardduty = true` for monitoring access to student data. Restrict `allowed_regions` to domestic regions.
- **Azure**: Set `enable_defender = true` and `log_retention_days = 365` for FERPA audit requirements.
- **GCP**: Restrict `allowed_regions` to domestic regions.
- **Identity**: Configure `saml_metadata_document` from the institution's IdP (e.g., Shibboleth for InCommon federation).
- Apply `tags` with `data-classification: ferpa` across all environments.
### Example Use Case
A state education system deploys landing zones in AWS and Azure with Shibboleth-based SAML federation, domestic-only region restrictions, CloudTrail and Defender monitoring for student data access, and FERPA compliance tags on all resources.

## SaaS / Multi-Tenant
### Compliance Requirements
- SOC 2, ISO 27001
### Configuration Changes
- **AWS**: Set `enable_security_hub = true` and `enable_guardduty = true` for SOC 2 security monitoring evidence. Use `enable_control_tower = true` for multi-account tenant isolation.
- **Azure**: Configure management groups via `root_management_group_name` for tenant subscription organization. Set `enable_defender = true`.
- **GCP**: Use `project_prefix` for consistent tenant project naming. Configure `billing_account` for consolidated billing.
- **Identity**: Configure `saml_metadata_document` for enterprise SSO. Use `gcp_workforce_pool_id` and `aws_sso_arn` for unified access management.
- Apply `tags` with `tenant-tier` and `cost-center` labels for chargeback and governance.
### Example Use Case
A multi-cloud SaaS provider uses Control Tower for AWS account-per-tenant isolation, Azure management groups for subscription organization, GCP projects per tenant, and federated identity for unified operator access across all three clouds.

## Cross-Industry Best Practices
- Use environment-based configuration by parameterizing `tags`/`labels`, `allowed_regions`/`allowed_locations`, and identity settings per environment.
- Always enable encryption in transit by enforcing TLS across all cloud provider APIs and configuring VPN/ExpressRoute/Cloud Interconnect for hybrid connectivity.
- Enable audit logging by setting `enable_cloudtrail = true` (AWS), `log_retention_days = 365` (Azure), and organization-level audit logs (GCP).
- Enforce least-privilege access controls via federated identity (`saml_metadata_document`) with MFA and region-restricted SCPs/policies.
- Implement network segmentation by deploying separate landing zones and accounts/subscriptions/projects per workload classification.
- Configure backup and disaster recovery with multi-region landing zone deployments and cross-cloud identity federation for failover access.
