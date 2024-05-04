#!/bin/bash
#
# Criar o comando para fazer join
#
#
#######################################################################


echo 'Criar kubeadm join token'
join_command="$(kubeadm token create --print-join-command)"
join_command="$join_command --cri-socket /run/containerd/containerd.sock"

echo 'Subindo os certificados para o novo controlplane e obter o token'
TOKEN_CERT=$(kubeadm init phase upload-certs --upload-certs 2> /dev/null | tail -1)

echo 'Gerando arquivo /opt/join-controlplane.sh'
echo "$join_command --control-plane --certificate-key $TOKEN_CERT" > /opt/join-controlplane.sh
chmod +x /opt/join-controlplane.sh

echo 'Gerando arquivo /opt/join-worker.sh'
echo "$join_command" > /opt/join-worker.sh
chmod +x /opt/join-worker.sh




