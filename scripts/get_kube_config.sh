#!/usr/bin/env bash

echo "This will overwrite your ~/.kube/config"
echo "Are you sure you want to do this (y|n)?"

read CONFIRM

if [[ $CONFIRM == "y" ]];then
  terraform output kubeconfig > ~/.kube/config
  echo "Done!"
else
  echo "Canceled! Nothing done."
fi

exit 0
