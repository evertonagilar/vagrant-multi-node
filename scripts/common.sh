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


echo 'Configurar /etc/hosts'
echo "$VM_VIRTUAL_IP $VM_DNS_VIRTUAL_IP.${VM_DNS_PREFIX}" >> /etc/hosts
for i in $(seq 1 $VM_CONTROLPLANE_COUNT); do
    node="${VM_MASTER_BASE_NAME}${i}"
    node_fqdn="${node}.${VM_DNS_PREFIX}"
    ip="${VM_IP_SUFIX}.$((VM_IP_START + i))"
    echo "$ip ${node} ${node_fqdn}" >> /etc/hosts
done


### --------------------------------

echo 'Configurar parâmetro ssh PasswordAuthentication para yes'
sed -i \
    's/^PasswordAuthentication .*/PasswordAuthentication yes/' \
    /etc/ssh/sshd_config


### --------------------------------

echo 'Configurar parâmetro ssh PermitRootLogin para yes'
sed -i \
  's/^#PermitRootLogin.*/PermitRootLogin yes/' \
  /etc/ssh/sshd_config


### --------------------------------

echo 'Configurar parâmetro ssh StrictHostKeyChecking para no'
cat << EOF >> /home/vagrant/.ssh/config
Host ${VM_IP_SUFIX}.*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF
chmod 600 /home/vagrant/.ssh/config


### --------------------------------

echo 'Configurar chave ssh'
if [ ! -f "/vagrant/config/ssh/k8s-multinode" ]; then
    echo 'Criando nova chave ssh para comunicação inter-node'
    rm -rf /vagrant/config/ssh
    mkdir /vagrant/config/ssh
    ssh-keygen -t rsa -C 'Chave k8s-multinode project' -N '' -f "/vagrant/config/ssh/k8s-multinode"
fi

echo "Copiando chave privada e pública para /home/vagrant/.ssh/"
cp "/vagrant/config/ssh/k8s-multinode" "/vagrant/config/ssh/k8s-multinode.pub" /home/vagrant/.ssh/
cat "/vagrant/config/ssh/k8s-multinode.pub" >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/k8s-multinode
chmod 644 /home/vagrant/.ssh/k8s-multinode.pub


### --------------------------------

echo 'Reload sshd'
systemctl reload sshd


### --------------------------------


echo 'Configurar senha do root'
echo -e "$VM_PASSWD_ROOT\$VM_PASSWD_ROOT" | passwd root >/dev/null 2>&1


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

