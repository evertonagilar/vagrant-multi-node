#!/bin/bash
#
# Faz o join de um worker
#
#
#######################################################################


### --------------------------------

controlplane1="${VM_MASTER_BASE_NAME}1"

echo "Recuperar o join command no $controlplane1"
scp -i /home/vagrant/.ssh/k8s-multinode vagrant@$controlplane1:/opt/join-worker.sh /tmp


### --------------------------------

echo "Executar /tmp/join-worker.sh"
echo " --node-name $VM_HOSTNAME --apiserver-advertise-address=$VM_IP" >> /tmp/join-worker.sh
tr -d '\n' < /tmp/join-worker.sh > /tmp/join-worker2.sh
cat /tmp/join-worker2.sh
source /tmp/join-worker2.sh

### --------------------------------

echo 'Criar o kubeconfig no usuário root'
mkdir -p /root/.kube
cp /vagrant/config/kubernetes/admin.conf /root/.kube/config


### --------------------------------

echo 'Criar o kubeconfig no usuário vagrant'
mkdir -p /home/vagrant/.kube
cp /vagrant/config/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

