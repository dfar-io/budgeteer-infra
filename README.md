![TFLint](https://github.com/dfar-io/budgeteer-infra/actions/workflows/tflint.yml/badge.svg)

# budgeteer-infra

Infrastructure components for Budgeteer budgeting application.

## Getting Started

1. Create Codespace.
2. Set up and run Terraform manually.
```
. ./init.sh
terraform apply
```

## Notes

Setting up Cloud Run custom domain requires a certificate provision, which requires DNS records to be created.
Might need to make DNS entries before provisioning infrastructure.

## Troubleshooting

Authentication issues when running `tfplan`: check if PAT is expired.