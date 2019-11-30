#!/bin/bash

declare -a NAMESPACES=("nmsp1" "nmsp2" "nmsp3")

NUM_NAMESPACES=${#NAMESPACES[@]}

for (( i=1; i<${NUM_NAMESPACES}+1; i++ ));
do
  echo $i " / " ${NUM_NAMESPACES} " : " ${NAMESPACES[$i-1]}
  source helm-env.sh ${NAMESPACES[$i-1]} "${NAMESPACES[$i-1]}/certs" user1
  helm --tiller-namespace ${NAMESPACES[$i-1]} version
done

echo -e "\nDone!"

exit 0
