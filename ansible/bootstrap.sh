#!/bin/bash

echo '********** Chamando scripts common **********'
source common/ssh/ssh-internode-config.sh
source common/so/so-common.sh

echo 'Adicionar a chave do repositório APT do ansible'
wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg

echo 'Adicionar o repositório APT do ansible'
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/ansible.list

echo 'Instalar ansible'
sudo apt update && sudo apt install -y ansible

echo 'Cadastrar máquinas máquinas do cluster em /etc/hosts'
cat <<EOF >> /etc/hosts
192.168.10.11   vm-controlplane1
192.168.10.12   vm-controlplane2
192.168.10.13   vm-controlplane3
192.168.10.16   vm-worker1
192.168.10.17   vm-worker2
EOF


