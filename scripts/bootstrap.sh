#!/bin/bash

echo 'Cadastrar variáveis do Vagrantfile em /etc/environment'
vm_variables=$(env | grep -E '^VM_')
vm_variable_names=(${vm_variables[@]})
for vm_variable in "${vm_variables[@]}"; do
  vm_variable_name=${vm_variable%%=*}
  vm_variable_value=${vm_variable#*=}
  echo "$vm_variable_name=$vm_variable_value" | tee -a /etc/environment
done


### --------------------------------

echo 'Chamando os scripts para provisionar o cluster Kubernetes...'
source scripts/common.sh
source scripts/k8s-common.sh

# *** Executar em controlplane ***
if [ -n "$VM_CONTROLPLANE_NUMBER" ]; then
    source scripts/keepalived.sh
    if [ "$VM_CONTROLPLANE_NUMBER" == "1" ]; then
        source scripts/k8s-init.sh
        source scripts/k8s-join-print.sh
    else
        source scripts/k8s-join-controlplane.sh
    fi

# **** Executar em worker node ***
else
    source scripts/k8s-join-worker.sh
fi