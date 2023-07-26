#!/bin/bash
message="Auto-Commit: $1"

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