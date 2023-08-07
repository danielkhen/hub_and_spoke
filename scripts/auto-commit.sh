#!/bin/bash
message="Auto-Commit: $1"

bash update-terraform-docs.sh
cd ..
terraform fmt --recursive

for module in modules/*/;
do
  cd $module
  pwd
  git add -A
  git commit -m "$message"
  git push
  cd ../..
done

pwd
git add -A
git commit -m "$message"
git push