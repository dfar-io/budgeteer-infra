# https://cloud.google.com/docs/terraform/resource-management/store-state
# just created the bucket manually and link to it via terraform init

provider "google" {
    region  = "us-east4"
}

terraform {
    required_version = "~> 1.10.3"
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "~> 6.14.1"
        }
        random = {
            source  = "hashicorp/random"
            version = "~> 3.6.3"
        }
        github = {
            source  = "integrations/github"
            version = "~> 6.4.0"
        }
        null = {
            source  = "hashicorp/null"
            version = "~> 3.2.3"
        }
    }
    backend "gcs" {
        bucket = "budgeteer-tf-state"
    }
}