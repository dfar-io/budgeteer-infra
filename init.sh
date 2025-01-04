export GITHUB_TOKEN=
echo 'Logging into GitHub...'
echo
gh auth login -p https -w
echo 'Logging into GCP...'
echo
gcloud auth application-default login
terraform init