![TFLint](https://github.com/dfar-io/budgeteer-infra/actions/workflows/tflint.yml/badge.svg)

# budgeteer-infra

Infrastructure components for Budgeteer budgeting application.

## Pre-reqs

1. Create a storage bucket in another GCP project that will serve as Terraform state. 

## Getting Started

1. Create Codespace.
2. Set up and run Terraform manually.
```
. ./init.sh
terraform apply
```

## Troubleshooting

Provider produced inconsistent final plan: try running again, this happens on an
initial provision because of Cloud Run domain mappings.

Authentication issues when running `tfplan`: check if PAT is expired.