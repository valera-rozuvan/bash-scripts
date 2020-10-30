#!/bin/bash

kubectl config unset current-context
gcloud config set account "user@example.com"
gcloud config configurations activate CONFIGURATION_NAME
gcloud config set core/account "user@example.com"
gcloud config set core/project PROJECT_NAME
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

echo "Done!"
exit 0
