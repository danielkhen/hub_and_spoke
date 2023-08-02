#!/bin/bash

modules_to_exclude=("ip_address_management")
cd ..

for module in modules/*/;
do
  (
  module_name=$(basename "$module")

  if [[ " ${modules_to_exclude[*]} " == *" $module_name "* ]]; then
    echo "Skipping tests for module: $module_name"
  else
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

      destroy_output=$(terraform -chdir="$module/tests" destroy -auto-approve 2>&1 >/dev/null)

      if [ $? -ne 0 ]; then
        echo "Error in tests destroy $module_name:"
        echo "$destroy_output"
      fi
    fi
  fi
  ) &
done

wait

echo "Done!!!"