terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket         = "acme-corp-terraform-state"
    key            = "multi-cloud-landing-zone/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "production"
      ManagedBy   = "terraform"
      Project     = "multi-cloud-landing-zone"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

provider "google" {
  project = "acme-corp-seed-project"
  region  = "us-central1"
}
