#!/bin/bash
#
# Objetivos do script:
# ====================================================================
# * Configurar /etc/hosts
# * Configurar locale pt_BR.UTF-8
# * Configurar o timezone para America/Sao_Paulo
# * Instalação de pacotes básicos 
# * Criar /etc/apt/keyrings se não existe
# * Configurar o vim
#
#
#######################################################################

echo '------------------------ Faz a cofiguração básica no SO ------------------------'

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
apt install -y vim apt-transport-https ca-certificates curl wget gnupg lsb-release nfs-common htop chrony python3-pip jq


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



