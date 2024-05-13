#!/bin/bash
#
# Objetivos do script:
# ====================================================================
# * Configurar /etc/hosts
# * Configurar comunicação ssh entre VMs
# * Configurar locale pt_BR.UTF-8
# * Configurar o timezone para America/Sao_Paulo
# * Instalação de pacotes básicos 
# * Criar /etc/apt/keyrings se não existe
# * Configurar o vim
# * Desabilitar o swap
#
#
#######################################################################


echo 'Cadastrar máquinas virtuais em /etc/hosts'
echo "$VM_VIRTUAL_IP $VM_DNS_VIRTUAL_IP $VM_DNS_VIRTUAL_IP.${VM_DNS_PREFIX}" >> /etc/hosts
for i in $(seq 1 $VM_CONTROLPLANE_COUNT); do
    node="${VM_MASTER_BASE_NAME}${i}"
    node_fqdn="${node}.${VM_DNS_PREFIX}"
    ip="${VM_IP_SUFIX}.$((VM_IP_CONTROLPLANE_START + i))"
    echo "$ip ${node} ${node_fqdn}" >> /etc/hosts
done
for i in $(seq 1 $VM_WORKER_COUNT); do
    node="${VM_WORKER_BASE_NAME}${i}"
    node_fqdn="${node}.${VM_DNS_PREFIX}"
    ip="${VM_IP_SUFIX}.$((VM_IP_WORKER_START + i))"
    echo "$ip ${node} ${node_fqdn}" >> /etc/hosts
done



### --------------------------------


echo 'Configurar o locale pt_BR.UTF-8'
export LANG=pt_BR.UTF-8
echo "LANG=${LANG}" >> /etc/environment
sed -i "s/# pt_BR.UTF-8 UTF-8/${LANG} UTF-8/" /etc/locale.gen
locale-gen "${LANG} UTF-8"


### --------------------------------


echo 'Configurar o timezone para America/Sao_Paulo'
echo America/Sao_Paulo | tee /etc/timezone
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata


### --------------------------------


echo 'Instalação de pacotes básicos'
apt install -y vim apt-transport-https ca-certificates curl wget gnupg lsb-release nfs-common htop chrony


### --------------------------------


echo 'Criar /etc/apt/keyrings se não existe'
mkdir -p /etc/apt/keyrings
chmod 755 -R /etc/apt/keyrings


### --------------------------------


echo 'Configurar o vim'
cat << EOF > /root/.vimrc
set nomodeline
set bg=dark
set tabstop=2
set expandtab
set ruler
set nu
syntax on
EOF
cp /root/.vimrc /home/vagrant/.vimrc && chown vagrant:vagrant /home/vagrant/.vimrc


### --------------------------------


echo 'Desabilitar o swap'
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


### --------------------------------

