#!/bin/bash
message="Auto-Commit: $1"

for module in modules/*/;
do
  cd $module
  pwd
  git rm -f tests/.terraform/
  git add -A
  git commit -m "$message"

  git filter-branch --force --index-filter 'git rm -r --cached --ignore-unmatch tests/.terraform/' --prune-empty --tag-name-filter cat -- --all
  git reflog expire --expire=now --all && git gc --prune=now --aggressive


  git push origin main --force

  cd ../..
done

pwd
git add -A
git commit -m "$message"
git filter-branch --force --index-filter 'git rm -r --cached --ignore-unmatch tests/.terraform/' --prune-empty --tag-name-filter cat -- --all
git reflog expire --expire=now --all && git gc --prune=now --aggressive


git push origin main --force