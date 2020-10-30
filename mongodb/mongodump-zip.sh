#!/bin/bash

db_host=""
db_port=""
auth_user=""
auth_pswd=""
db_name=""

project_name=""
bckp_folder_name="mongodump-${project_name}-$(date | sed 's/ /-/g')"
zip_file_name="${bckp_folder_name}.zip"

mongodump --host $db_host --port $db_port \
  --username $auth_user --password $auth_pswd \
  -d $db_name \
  --out $bckp_folder_name
zip -r $zip_file_name $bckp_folder_name

rm -rf $bckp_folder_name

# Delete backups older than 30 days
find *.zip -mtime +30 -exec rm -rf {} \;

echo "Done!"
exit 0
