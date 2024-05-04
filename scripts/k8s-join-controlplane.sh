#!/bin/bash
#
# Faz o join de um control-plane
#
#
#######################################################################


### --------------------------------

echo "Recuperar o join command no control-plane 1"
controlplane1="${VM_MASTER_BASE_NAME}1"
sudo -u vagrant scp -i /home/vagrant/.ssh/k8s-multinode vagrant@$controlplane1:/opt/join-controlplane.sh /tmp


### --------------------------------

echo "Executar /tmp/join-controlplane.sh"
source /tmp/join-controlplane.sh

### --------------------------------

