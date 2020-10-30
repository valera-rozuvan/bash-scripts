#!/bin/bash

GITHUB_TOKEN="__github_API_token_goes_here__"
GITHUB_ORG_NAME="__github_org_name_goes_here__"

curl \
  -H "Authorization: token ${GITHUB_TOKEN}" \
  -s "https://api.github.com/orgs/${GITHUB_ORG_NAME}/repos?page=1&per_page=100" | \

grep -w clone_url | \
grep -o '[^"]\+://.\+.git' > repos.sh

exit 0
