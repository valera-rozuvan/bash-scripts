#!/bin/bash

db_host=""
db_port=""
auth_user=""
auth_pswd=""
db_name=""

bckp_folder_name=""

mongorestore
  --host $db_host --port $db_port \
  --username $auth_user --password $auth_pswd \
  --db $db_name \
  --drop \
  $bckp_folder_name

echo "Done!"
exit 0
