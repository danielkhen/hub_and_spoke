#!/bin/bash

for module in modules/*/;
do
  cd $module/tests
  pwd
  terraform init -upgrade
  terraform apply -auto-approve
  cd ../../..
done