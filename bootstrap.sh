#!/bin/bash

echo Configurar comunicação ssh entre VMs
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd
echo 'Definindo senha do root para teste'
echo -e "teste\nteste" | passwd root >/dev/null 2>&1


### --------------------------------


echo Configurar o locale pt_BR.UTF-8
export LANG=pt_BR.UTF-8
echo "LANG=${LANG}" |  tee -a /etc/environment
sed -i "s/# pt_BR.UTF-8 UTF-8/${LANG} UTF-8/" /etc/locale.gen
locale-gen "${LANG} UTF-8"


### --------------------------------


echo Configurar o timezone para America/Sao_Paulo
echo America/Sao_Paulo |  tee /etc/timezone
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata


### --------------------------------


echo Instalação dos pacotes necessários para a utilização do Kubernetes
apt install -y vim apt-transport-https ca-certificates curl wget gnupg lsb-release nfs-common htop chrony


### --------------------------------


echo Criar /etc/apt/keyrings se não existe
mkdir -p /etc/apt/keyrings
chmod 755 -R /etc/apt/keyrings


### --------------------------------


echo Configurar o vim
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


reboot
