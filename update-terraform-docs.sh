#!/bin/bash

for module in modules/*/;
do
  cd $module
  pwd
  terraform-docs -c ./terraform_docs_config.yml .
  cd ../..
done

pwd
terraform-docs -c ./terraform_docs_config.yml .