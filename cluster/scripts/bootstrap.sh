#!/bin/bash

echo 'Cadastrar variáveis do Vagrantfile em /etc/environment'
vm_variables=$(env | grep -E '^VM_')
vm_variable_names=(${vm_variables[@]})
for vm_variable in "${vm_variables[@]}"; do
  vm_variable_name=${vm_variable%%=*}
  vm_variable_value=${vm_variable#*=}
  echo "$vm_variable_name=$vm_variable_value" | tee -a /etc/environment
done
echo ETCDCTL_API=$ETCDCTL_API | tee -a /etc/environment


### --------------------------------

echo 'Chamando os scripts da pasta common do projeto...'
source common/ssh/ssh-internode-config.sh

echo 'Chamando os scripts da pasta cluster do projeto...'
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
    source scripts/k8s-etcdctl.sh
# **** Executar em worker node ***
else
    source scripts/k8s-join-worker.sh
fi