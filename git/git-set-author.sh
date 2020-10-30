#!/bin/bash

echo "[user]" >> .git/config
echo "  name = Valera Rozuvan" >> .git/config
echo "  email = valera.rozuvan@gmail.com" >> .git/config
echo "  signingkey = AF7ED678" >> .git/config
echo "[gpg]" >> .git/config
echo "  program = gpg2" >> .git/config
echo "[commit]" >> .git/config
echo "  gpgsign = true" >> .git/config

echo "Done!"
exit 0
