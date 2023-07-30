#!/bin/bash

cd ..

for module in modules/*/;
do
  (
  terraform -chdir=$module/tests init -upgrade 2> scripts/test-errors.logs
  terraform -chdir=$module/tests apply -auto-approve 2> scripts/test-errors.logs
  ) &
done