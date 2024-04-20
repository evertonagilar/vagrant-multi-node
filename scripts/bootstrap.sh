#!/bin/bash

### --------------------------------

echo 'Exibir as variávies e cadastrar em /etc/environment'
vm_variables=$(env | grep -E '^VM_')
vm_variable_names=(${vm_variables[@]})
for vm_variable in "${vm_variables[@]}"; do
  vm_variable_name=${vm_variable%%=*}
  vm_variable_value=${vm_variable#*=}
  echo "$vm_variable_name=$vm_variable_value" | tee -a /etc/environment
done


### --------------------------------

echo 'Chamando os scripts'
source scripts/common.sh
source scripts/k8s.sh
source scripts/keepalived.sh