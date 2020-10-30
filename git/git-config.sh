#!/bin/bash

ssh-keygen -t rsa -b 4096 -C "your@email"
git config --global commit.gpgsign true
git config --global --edit
git commit --amend --reset-author

echo "Done!"
exit 0
