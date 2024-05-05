#!/bin/bash
#
# Criar o cluster Kubernetes
#
#
#######################################################################


# Variáveis

echo
echo "Versão do Kubernetes: $VM_K8S_VERSION"
echo "Versão CALICO: $VM_CALICO_VERSION"
echo "VM_POD_NETWORK_CIDR: $VM_POD_NETWORK_CIDR"
echo "VM_SERVICE_CIDR: $VM_SERVICE_CIDR"
echo



### --------------------------------

echo 'Executar o kubeadm init para criar o cluster'
kubeadm init --apiserver-advertise-address=$VM_IP \
--control-plane-endpoint $VM_CONTROL_PLANE_ENDPOINT \
--upload-certs \
--node-name $VM_HOSTNAME \
--pod-network-cidr=$VM_POD_NETWORK_CIDR \
--service-cidr=$VM_SERVICE_CIDR \
--apiserver-cert-extra-sans=$VM_VIRTUAL_IP,$VM_IP,$VM_HOSTNAME \
--cri-socket unix:///run/containerd/containerd.sock

### --------------------------------


echo 'Criar o kubeconfig no usuário root'
mkdir -p "$HOME"/.kube
cp /etc/kubernetes/admin.conf "$HOME"/.kube/config


### --------------------------------

echo 'Criar o kubeconfig no usuário vagrant'
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

### --------------------------------

echo 'Copiar pasta /etc/kubernetes para a pasta config do projeto'
rm -rf /vagrant/config/kubernetes
cp -R /etc/kubernetes /vagrant/config

### --------------------------------

echo 'Instalar plugin de rede Calico CNI'
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/$VM_CALICO_VERSION/manifests/calico.yaml

