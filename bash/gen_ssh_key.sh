#!/bin/bash

KEY_TYPE="ed25519"

KEY_HASH=$(rnd_str 32)
KEY_PSWD=$(rnd_str 64)

mkdir -p ~/.ssh/$KEY_HASH
ssh-keygen -C $KEY_HASH -f ~/.ssh/$KEY_HASH/ed25519 -P $KEY_PSWD -t $KEY_TYPE > /dev/null 2>&1

echo "Key type: ${KEY_TYPE}"
echo "Key hash: ${KEY_HASH}"
echo -e "Key pswd: ${KEY_PSWD}\n"

echo "Public key:"
cat ~/.ssh/$KEY_HASH/$KEY_TYPE.pub

echo -e "\nPrivate key:"
cat ~/.ssh/$KEY_HASH/$KEY_TYPE

exit 0
