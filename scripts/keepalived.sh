#!/bin/bash
#
# Instalar o load balancer do cluster Kubernetes
#
# Objetivos do script:
# ====================================================================
#
#
#######################################################################


echo 'Exibir variáveis'
echo VM_COUNT=$VM_COUNT
echo VM_TYPE=$VM_TYPE
echo VM_BOX=$VM_BOX
echo VM_BOX_VERSION=$VM_BOX_VERSION
echo VM_IP_SUFIX=$VM_IP_SUFIX
echo VM_IP_START=$VM_IP_START
echo VM_MASTER_NODE_NAME=$VM_MASTER_NODE_NAME
echo VM_HOSTNAME=$VM_HOSTNAME
echo VM_IP=$VM_IP
echo VM_VIRTUAL_IP=$VM_VIRTUAL_IP
echo VM_DNS_PREFIX=$VM_DNS_PREFIX
echo VM_DNS_VIRTUAL_IP=$VM_DNS_VIRTUAL_IP
echo VM_VRRP_PRIORIDADE=$VM_VRRP_PRIORIDADE
echo VM_VRRP_TYPE_INSTANCE=$VM_VRRP_TYPE_INSTANCE


### --------------------------------


echo 'Instalar o keepalived'
apt install -y keepalived


### --------------------------------


echo 'Criar o script para monitoramento da API /etc/keepalived/check_apiserver.sh'
envsubst < /vagrant/config/check_apiserver.sh | tee /etc/keepalived/check_apiserver.sh


### --------------------------------

echo 'Criar o arquivo de configuração do keepalived'
envsubst < /vagrant/config/keepalived.conf | tee /etc/keepalived/keepalived.conf
