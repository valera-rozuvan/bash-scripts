#!/bin/bash

VM_NAME="vm-$(head /dev/urandom | tr -dc a-z0-9 | head -c 16 ; echo '')"

function do_work {
  echo "[${VM_NAME}] Creating VM..."
  gcloud beta compute \
    --project=valvpn \
    instances create $VM_NAME \
    --zone=us-central1-a \
    --machine-type=e2-micro \
    --subnet=default \
    --network-tier=PREMIUM \
    --metadata=block-project-ssh-keys=true,ssh-keys=valera.rozuvan:ssh-rsa\ AAAAB3NzaC1yc2EAAAADAQABAAACAQDE2a\+jvyu2XNSlJ3Lo0kBS\+KA/5ZVrhUHw\+t6BUX4z1/3meCzt5pB/EWvLNOABjGcYNg4AVzzl01B0bReSinIa\+7H8cRQtjW4fnioFOhu\+TRRPe5sXGBfdnehh4lrkpSAs6x/bnb\+j6OrQQsngXU6y\+FH1GcS98cWTCq76TT9yIQQqJ76bckDcGiMQrZk\+eJK7qDYz6CW5zQFiec1vZIwCEU6OboEWC55quQu1rG23oV/CFVy5GHls8py2bBPCXwPtxagIN8iE4zIxqjR9rk\+yWulWJYR3U6FbzFmvfDAO2aGbKzIauWJ\+Uzw7LVRb90YHGTGa1n\+35Ej17NOFiFJstU\+7AytKhVDetCoEp9aUp6jV\+2aNWBMraBHGTX/\+5PwbUf1dZ0Yp12wuzC8u7Z4xba4AqZRqaf6IsIKNiZEwShzORrTiyqVctxG2dQkVPZOw444AO7h/yn8zlRQRrJD\+b2cXWEDrOo9Rlvk9RyIVgjtXUAiopYF\+QIPZH\+\+Z8wxpXv3bw9WTMbo3n0r7jiTZkGoAGNbW3\+84ycZeWpvAkuhiAOHKhy2qaUKBKFubza340A9T47xhO6EOHOT3/lzRoD1DpvtZpMl9Qb04S3dZA/PUEqtDOuJlmCe2rcDbjO5b48Kr9AXmhu9GnPMSB75xhJhtRvyI8hMN7R7gAEF8Sw==\ valera.rozuvan@gmail.com \
    --maintenance-policy=MIGRATE \
    --service-account=22155033208-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --tags=ssh,http-server,https-server \
    --image=debian-10-buster-v20200413 \
    --image-project=debian-cloud \
    --boot-disk-size=10GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=$VM_NAME \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any

  echo "[${VM_NAME}] Sleeping for 60s..."
  sleep 60s

  echo "[${VM_NAME}] Getting IP address..."
  IP_ADDRESS=$(gcloud compute instances describe $VM_NAME --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

  echo "[${VM_NAME}] Executing Bash script over SSH..."
  ssh -oStrictHostKeyChecking=no -oConnectTimeout=30 "valera.rozuvan@${IP_ADDRESS}" 'bash -s' < ./do-work.sh

  echo "[${VM_NAME}] Deleting VM..."
  gcloud compute instances delete $VM_NAME --zone=us-central1-a --delete-disks=all --quiet

  echo "[${VM_NAME}] Done!"
}

while true; do
  do_work

  echo "[${VM_NAME}] Waiting for 5 minutes until next round..."
  sleep 5m
done

exit 0
