#!/bin/bash

sudo apt-get update
sudo apt-get -y install curl git

cd ~/
git clone https://github.com/nvm-sh/nvm.git .nvm
cd ~/.nvm
git checkout v0.35.3
. nvm.sh
cd ~/

cat << EOF > index.js
const { div, add, λ, _ } = require('lambda-math');

λ( div, [300, 293] )
 ( add, [λ[0], λ[0]], [_, λ[0]], 70 );

console.log(λ[1].number);
EOF

nvm install v12
npm install lambda-math
node index.js

echo "Done!"
exit 0
