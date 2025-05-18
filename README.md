![TFLint](https://github.com/dfar-io/budgeteer-infra/actions/workflows/tfplan.yml/badge.svg)

# budgeteer-infra

Infrastructure components for Budgeteer budgeting application.

## Notes for myself

- I'm currently unable to authenticate for the service principal when using only a Cloud Run Domain Mapping. Just
setting it up so the URL redirects instead.

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

```
Provider produced inconsistent final plan
```
Try running again, this happens on an
initial provision because of Cloud Run domain mappings.

```
401 Bad credentials []
```
Check if PAT is expired.
