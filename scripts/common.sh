#!/bin/bash
#
# Fazer a configuração básica da VM
#
# Objetivos do script:
# ====================================================================
# * Cadastrar variáveis /etc/environment
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


### --------------------------------

echo 'Exibir variáveis'
echo VM_CONTROLPLANE_COUNT=$VM_CONTROLPLANE_COUNT
echo VM_CONTROLPLANE_NUMBER=$VM_CONTROLPLANE_NUMBER
echo VM_COUNT=$VM_COUNT
echo VM_TYPE=$VM_TYPE
echo VM_BOX=$VM_BOX
echo VM_BOX_VERSION=$VM_BOX_VERSION
echo VM_IP_SUFIX=$VM_IP_SUFIX
echo VM_IP_START=$VM_IP_START
echo VM_MASTER_NODE_NAME=$VM_MASTER_NODE_NAME
echo VM_WORKER_NODE_NAME=$VM_WORKER_NODE_NAME
echo VM_HOSTNAME=$VM_HOSTNAME
echo VM_IP=$VM_IP
echo VM_VIRTUAL_IP=$VM_VIRTUAL_IP
echo VM_DNS_PREFIX=$VM_DNS_PREFIX
echo VM_DNS_VIRTUAL_IP=$VM_DNS_VIRTUAL_IP
echo VM_K8S_VERSION=$VM_K8S_VERSION
echo VM_VRRP_PRIORIDADE=$VM_VRRP_PRIORIDADE
echo VM_VRRP_TYPE_INSTANCE=$VM_VRRP_TYPE_INSTANCE
echo VM_WORKER_NUMBER=$VM_WORKER_NUMBER
echo VM_WORKER_COUNT=$VM_WORKER_COUNT


### --------------------------------

echo 'Cadastrar variáveis /etc/environment'
if [ "$VM_TYPE" == 'controlplane' ]; then
    echo "VM_CONTROLPLANE_NUMBER=$VM_CONTROLPLANE_NUMBER" >> /etc/environment
    echo "VM_CONTROLPLANE_COUNT=$VM_CONTROLPLANE_COUNT" >> /etc/environment
    echo "VM_VRRP_PRIORIDADE=$VM_VRRP_PRIORIDADE" >> /etc/environment
    echo "VM_VRRP_TYPE_INSTANCE=$VM_VRRP_TYPE_INSTANCE" >> /etc/environment
else
    echo "VM_WORKER_NUMBER=$VM_WORKER_NUMBER" >> /etc/environment
    echo "VM_WORKER_COUNT=$VM_WORKER_COUNT" >> /etc/environment
fi
echo "VM_COUNT=$VM_COUNT" >> /etc/environment
echo "VM_TYPE=$VM_TYPE" >> /etc/environment
echo "VM_BOX=$VM_BOX" >> /etc/environment
echo "VM_BOX_VERSION=$VM_BOX_VERSION" >> /etc/environment
echo "VM_IP_SUFIX=$VM_IP_SUFIX" >> /etc/environment
echo "VM_IP_START=$VM_IP_START" >> /etc/environment
echo "VM_MASTER_NODE_NAME=$VM_MASTER_NODE_NAME" >> /etc/environment
echo "VM_WORKER_NODE_NAME=$VM_WORKER_NODE_NAME" >> /etc/environment
echo "VM_HOSTNAME=$VM_HOSTNAME" >> /etc/environment
echo "VM_IP=$VM_IP" >> /etc/environment
echo "VM_VIRTUAL_IP=$VM_VIRTUAL_IP" >> /etc/environment
echo "VM_DNS_PREFIX=$VM_DNS_PREFIX" >> /etc/environment
echo "VM_DNS_VIRTUAL_IP=$VM_DNS_VIRTUAL_IP" >> /etc/environment
echo "VM_K8S_VERSION=$VM_K8S_VERSION" >> /etc/environment




### --------------------------------


echo 'Configurar /etc/hosts'
echo "$VM_VIRTUAL_IP $VM_DNS_VIRTUAL_IP.${VM_DNS_PREFIX}" >> /etc/hosts
for i in $(seq 1 $VM_CONTROLPLANE_COUNT); do
    node="${VM_MASTER_NODE_NAME}${i}"
    node_fqdn="${node}.${VM_DNS_PREFIX}"
    ip="${VM_IP_SUFIX}.$((VM_IP_START + i))"
    echo "$ip ${node} ${node_fqdn}" >> /etc/hosts
done



echo 'Configurar comunicação ssh entre VMs'
sed -i \
    's/^PasswordAuthentication .*/PasswordAuthentication yes/' \
    /etc/ssh/sshd_config
sed -i \
  's/^#PermitRootLogin.*/PermitRootLogin yes/' \
  /etc/ssh/sshd_config
systemctl reload sshd


### --------------------------------


echo 'Configurar senha do root: teste'
echo -e "teste\nteste" | passwd root >/dev/null 2>&1


### --------------------------------


echo 'Configurar o locale pt_BR.UTF-8'
export LANG=pt_BR.UTF-8
echo "LANG=${LANG}" >> /etc/environment
sed -i "s/# pt_BR.UTF-8 UTF-8/${LANG} UTF-8/" /etc/locale.gen
locale-gen "${LANG} UTF-8"


### --------------------------------


echo 'Configurar o timezone para America/Sao_Paulo'
echo America/Sao_Paulo |  tee /etc/timezone
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

