#!/bin/sh

EC2_KEY="./ec2_instance_key.pem"
EC2_USER="ubuntu"
EC2_HOST="ec2-00-000-000-00.eu-west-1.compute.amazonaws.com"

LOCAL_APP_PATH="/Users/some_user/dev/repo/application/my-app"
REMOTE_APP_PATH="/home/ubuntu/repo/application"

# Remove unnecessary files.
rm -rf "${LOCAL_APP_PATH}/dist"
rm -rf "${LOCAL_APP_PATH}/node_modules"

# Stop the running container, and clean up files on the remote.
ssh -i "${EC2_KEY}" "${EC2_USER}@${EC2_HOST}" bash -c "'
cd $REMOTE_APP_PATH
./stop.sh
sudo chmod -R og+rw ./
rm -rf ./my-app/dist
rm -rf ./my-app/node_modules
'"

# Copy over new files.
scp -i "${EC2_KEY}" -r "${LOCAL_APP_PATH}" "${EC2_USER}@${EC2_HOST}:${REMOTE_APP_PATH}"

# Build image and run the application container.
ssh -i "${EC2_KEY}" "${EC2_USER}@${EC2_HOST}" bash -c "'
cd $REMOTE_APP_PATH
./build.sh
screen -d -m ./start.sh
'"

# NOTE:
#
# It is necessary to use screen because "./start.sh" is a never-ending script,
# and we want to exit cleanly from the script executing over SSH.
#
# If you want to check up on what is going on inside the screen on the server,
# you can login (via SSH) to the server, list running screens (screen -ls),
# and connect to the necessary screen (screen -r SCREEN_NAME). To detach again,
# simple ctrl+A d (note that that's a capital "a").

exit 0
