#!/bin/bash

curl \
  -H 'Authorization: token {YOUR_GITHUB_TOKEN}' \
  -s "https://api.github.com/orgs/{YOUR_ORG_NAME}/repos?page=1&per_page=100" | \

grep -w clone_url | \
grep -o '[^"]\+://.\+.git' > \

repos.sh

exit 0
