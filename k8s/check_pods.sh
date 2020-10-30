#!/bin/bash

NAMESPACE="__YOUR_CLUSTER_NAMESPACE__"
PODS=($(kubectl -n $NAMESPACE get pods | awk '{ print $1 }'))

# colors
RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
NO_COLOR='\033[0m' # No Color

for i in "${PODS[@]}"
do
  if [ "${i}" == "NAME" ]
  then
    continue
  fi

  echo -e "${i}:"

  kubectl -n $NAMESPACE exec -it $i -- /bin/bash -c "env | grep -i GOOGLE_APPLICATION_CREDENTIALS" > /dev/null 2>&1
  OUT=$?
  if [ $OUT -eq 0 ]; then
    echo -e "      GOOGLE_APPLICATION_CREDENTIALS - ${GREEN_COLOR}set${NO_COLOR}"
  else
    echo -e "      GOOGLE_APPLICATION_CREDENTIALS - ${RED_COLOR}Not set!${NO_COLOR}"
    echo -e "\n"
    continue
  fi

  kubectl -n $NAMESPACE exec -it $i -- /bin/bash -c "ls -ahl /var/secrets/google/key.json" > /dev/null 2>&1
  OUT=$?
  if [ $OUT -eq 0 ]; then
    echo -e "      /var/secrets/google/key.json - ${GREEN_COLOR}exists${NO_COLOR}"
  else
    echo -e "      /var/secrets/google/key.json - ${RED_COLOR}Does not exist!${NO_COLOR}"
    echo -e "\n"
    continue
  fi

  echo -e "\n"
done

echo "-------------------"
echo "Done!"

exit 0
