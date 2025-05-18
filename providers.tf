# https://cloud.google.com/docs/terraform/resource-management/store-state

locals {
    location = "us-east4"
}

provider "google" {
    region  = local.location
}

provider "github" {
    # needed for org secret
    owner =  "dfar-io"
}

terraform {
    required_version = "~> 1.12.0"
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "~> 6.20.0"
        }
        random = {
            source  = "hashicorp/random"
            version = "~> 3.6.3"
        }
        github = {
            source  = "integrations/github"
            version = "~> 6.5.0"
        }
        null = {
            source  = "hashicorp/null"
            version = "~> 3.2.3"
        }
    }
    backend "gcs" {
        # just created the bucket manually in a different project
        bucket = "budgeteer-tf-state"
    }
}
