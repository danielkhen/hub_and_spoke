#!/bin/bash

cd ..

for module in modules/*/;
do
  (
  module_name=$(basename "$module")
  error_output=$(terraform -chdir="$module/tests" init -upgrade 2>&1 >/dev/null)
  if [ $? -ne 0 ]; then
    echo "Error in tests init $module_name:"
    echo "$error_output"
  else
    apply_output=$(terraform -chdir="$module/tests" apply -auto-approve 2>&1 >/dev/null)
    if [ $? -ne 0 ]; then
      echo "Error in tests apply $module_name:"
      echo "$apply_output"
    fi
  fi
  ) &
done

wait

echo "Done!!!"