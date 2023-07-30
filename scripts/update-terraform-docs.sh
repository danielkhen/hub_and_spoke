#!/bin/bash

cd ..

for module in modules/*/;
do
  terraform-docs -c $module/terraform_docs_config.yml $module
done

pwd
terraform-docs -c ./terraform_docs_config.yml .