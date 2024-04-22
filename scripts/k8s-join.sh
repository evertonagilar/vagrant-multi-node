#!/bin/bash
#
# Faz o join de um control-plane ou workder node
#
#
#######################################################################


### --------------------------------

echo "Recuperar o join command no control-plane 1"
controlplane1="${VM_MASTER_BASE_NAME}1"
sudo -u vagrant scp -i /home/vagrant/.ssh/tmpkey vagrant@$controlplane1:/opt/join_token /tmp


### --------------------------------


if [ -n "$VM_CONTROLPLANE_NUMBER" ]; then
    echo 'Executar o join como control-plane'
    source /tmp/join_token
else
    echo 'Executar o join como worker-node'
    source /tmp/join_token
fi