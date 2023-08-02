#!/bin/bash
message="Auto-Commit: $1"

cd ..

for module in modules/*/;
do
  cd $module
  pwd
  git rm --cached tests/terraform.tfstate.backup
  git add -A
  git commit -m "$message"
  git push
  cd ../..
done

pwd
git add -A
git commit -m "$message"
git push