# Multi-Cloud Landing Zone

A comprehensive, production-ready multi-cloud landing zone reference architecture spanning AWS, Azure, and GCP. This project provides Terraform modules that establish secure, compliant, and well-governed cloud foundations with unified identity federation across all three major cloud providers.

## Architecture Overview

```mermaid
graph TB
    subgraph IdentityLayer["Identity Federation Layer"]
        style IdentityLayer fill:#4A90D9,stroke:#2C5F8A,color:#FFFFFF
        IDP["Enterprise IdP<br/>Azure AD / Okta"]
        SAML["SAML 2.0 / OIDC"]
        SCIM["SCIM Provisioning"]
    end

    subgraph AWSLanding["AWS Landing Zone"]
        style AWSLanding fill:#FF9900,stroke:#CC7A00,color:#FFFFFF
        ORG["AWS Organization"]
        SCP["Service Control Policies"]
        CT["Control Tower"]
        AWSSSO["AWS IAM Identity Center"]
        TRAIL["CloudTrail"]
        GD["GuardDuty"]
        SH["Security Hub"]
        subgraph AWSAccounts["Account Structure"]
            style AWSAccounts fill:#FFB84D,stroke:#CC7A00,color:#333333
            MGMT["Management Account"]
            LOG["Log Archive Account"]
            AUDIT["Audit Account"]
            SHARED["Shared Services"]
            WORKLOAD["Workload Accounts"]
        end
    end

    subgraph AzureLanding["Azure Landing Zone"]
        style AzureLanding fill:#0078D4,stroke:#005A9E,color:#FFFFFF
        TENANT["Azure AD Tenant"]
        MG["Management Groups"]
        POLICY["Azure Policy"]
        BP["Blueprints"]
        subgraph AzureSubs["Subscription Structure"]
            style AzureSubs fill:#4DA6FF,stroke:#0078D4,color:#333333
            PLATFORM["Platform Subscriptions"]
            IDENTITY["Identity Subscription"]
            CONNECTIVITY["Connectivity Sub"]
            AZMGMT["Management Sub"]
            AZWORKLOAD["Landing Zone Subs"]
        end
    end

    subgraph GCPLanding["GCP Landing Zone"]
        style GCPLanding fill:#4285F4,stroke:#2D5FBF,color:#FFFFFF
        GCPORG["GCP Organization"]
        FOLDERS["Folder Hierarchy"]
        ORGPOL["Org Policies"]
        subgraph GCPProjects["Project Structure"]
            style GCPProjects fill:#79ACF7,stroke:#4285F4,color:#333333
            SEED["Seed Project"]
            GCPLOG["Logging Project"]
            GCPNET["Networking Project"]
            GCPSEC["Security Project"]
            GCPWORK["Workload Projects"]
        end
    end

    subgraph Governance["Unified Governance"]
        style Governance fill:#34A853,stroke:#267D3E,color:#FFFFFF
        TAGGING["Tagging Standards"]
        COSTMGMT["Cost Management"]
        COMPLIANCE["Compliance Reporting"]
        DRIFT["Drift Detection"]
    end

    subgraph Networking["Cross-Cloud Networking"]
        style Networking fill:#EA4335,stroke:#B5342A,color:#FFFFFF
        TGW["AWS Transit Gateway"]
        VWAN["Azure Virtual WAN"]
        NCC["GCP Network Connectivity"]
        VPN["Cross-Cloud VPN Mesh"]
    end

    IDP --> SAML
    IDP --> SCIM
    SAML --> AWSSSO
    SAML --> TENANT
    SAML --> GCPORG
    SCIM --> AWSSSO
    SCIM --> TENANT

    ORG --> SCP --> CT
    CT --> AWSAccounts
    MGMT --> TRAIL
    MGMT --> GD
    MGMT --> SH

    TENANT --> MG --> POLICY
    POLICY --> BP --> AzureSubs

    GCPORG --> FOLDERS --> ORGPOL
    ORGPOL --> GCPProjects

    AWSAccounts --> Governance
    AzureSubs --> Governance
    GCPProjects --> Governance

    TGW --> VPN
    VWAN --> VPN
    NCC --> VPN
```

## Project Structure

```
multi-cloud-landing-zone/
├── modules/
│   ├── aws-landing-zone/      # AWS Organization, SCPs, Control Tower
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── azure-landing-zone/    # Management Groups, Policy, Blueprints
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── gcp-landing-zone/      # Organization, Folders, Org Policies
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── identity-federation/   # Cross-cloud SSO and RBAC
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── LICENSE
├── CHANGELOG.md
└── README.md
```

## Features

- **AWS Landing Zone**: Automated multi-account setup with AWS Organizations, Service Control Policies, and Control Tower guardrails
- **Azure Landing Zone**: Enterprise-scale architecture with Management Groups, Azure Policy, and Blueprints aligned to CAF
- **GCP Landing Zone**: Organization hierarchy with Folders, Org Policies, and project factory pattern
- **Identity Federation**: Centralized identity with SAML 2.0/OIDC federation and SCIM provisioning across all clouds
- **Unified Governance**: Consistent tagging, cost management, compliance reporting, and drift detection
- **Cross-Cloud Networking**: VPN mesh connectivity between AWS Transit Gateway, Azure Virtual WAN, and GCP Network Connectivity Center

## Usage

```hcl
module "aws_landing_zone" {
  source = "./modules/aws-landing-zone"

  organization_name     = "my-org"
  enable_control_tower  = true
  enable_guardduty      = true
  enable_security_hub   = true
  allowed_regions       = ["us-east-1", "eu-west-1"]
}

module "azure_landing_zone" {
  source = "./modules/azure-landing-zone"

  root_management_group_name = "my-org"
  enable_defender            = true
  allowed_locations          = ["eastus", "westeurope"]
}

module "gcp_landing_zone" {
  source = "./modules/gcp-landing-zone"

  org_id          = "123456789"
  billing_account = "XXXXXX-XXXXXX-XXXXXX"
  allowed_regions = ["us-central1", "europe-west1"]
}

module "identity_federation" {
  source = "./modules/identity-federation"

  idp_metadata_url = "https://login.microsoftonline.com/.../metadata"
  aws_sso_arn      = module.aws_landing_zone.sso_instance_arn
  gcp_org_id       = module.gcp_landing_zone.org_id
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
