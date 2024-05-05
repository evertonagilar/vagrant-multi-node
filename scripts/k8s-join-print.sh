#!/bin/bash
#
# Criar o comando para fazer join
#
#
#######################################################################


echo 'Criar kubeadm join token'
join_command="$(kubeadm token create --print-join-command)"

echo 'Subindo os certificados para o novo controlplane e obter o token'
TOKEN_CERT=$(kubeadm init phase upload-certs --upload-certs 2> /dev/null | tail -1)

echo 'Gerando arquivo /opt/join-controlplane.sh'
echo "$join_command --cri-socket unix:///run/containerd/containerd.sock --control-plane --certificate-key $TOKEN_CERT " > /opt/join-controlplane.sh
chmod +x /opt/join-controlplane.sh

echo 'Gerando arquivo /opt/join-worker.sh'
echo "$join_command --cri-socket unix:///run/containerd/containerd.sock " > /opt/join-worker.sh
chmod +x /opt/join-worker.sh




