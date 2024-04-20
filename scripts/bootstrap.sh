#!/bin/bash

echo 'Exibir as variáveis e cadastrar em /etc/environment'
vm_variables=$(env | grep -E '^VM_')
vm_variable_names=(${vm_variables[@]})
for vm_variable in "${vm_variables[@]}"; do
  vm_variable_name=${vm_variable%%=*}
  vm_variable_value=${vm_variable#*=}
  echo "$vm_variable_name=$vm_variable_value" | tee -a /etc/environment
done


### --------------------------------

echo 'Chamando os scripts para provisionar o servidor...'
source scripts/common.sh
source scripts/k8s.sh
source scripts/keepalived.sh