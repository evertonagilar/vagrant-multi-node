#!/bin/bash

echo 'Chamando os scripts da pasta common do projeto...'
pwd
ls -l
source common/ssh/ssh-internode-config.sh

echo 'Instalar ansible'
apt install -y ansible
cat <<EOF >> /etc/hosts
192.168.10.11   vm-controlplane1
192.168.10.12   vm-controlplane2
192.168.10.13   vm-controlplane3
192.168.10.16   vm-worker1
192.168.10.17   vm-worker2
EOF

