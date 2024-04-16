#!/bin/bash


# Variáveis

K8S_VERSION=1.29.3-1.1

echo
echo A versão do Kubernetes será: $K8S_VERSION
echo


### --------------------------------


echo Download da chave publica do Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


echo Adicionar o repo Kubernetes
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list


### --------------------------------


echo Download da chave publica do Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo Adicionar o repo Docker.
sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


### --------------------------------


sudo apt update


### --------------------------------


echo Instalar Containerd
sudo apt install containerd.io

echo Marcar para não atualizar containerd.io junto com o apt upgrade
sudo apt-mark hold containerd.io


### --------------------------------


echo Instalar o Kubernetes versão $K8S_VERSION
sudo apt install -y kubelet=$K8S_VERSION kubeadm=$K8S_VERSION kubectl=$K8S_VERSION


echo Marcar para não atualizar Kubernetes junto com o apt upgrade
sudo apt-mark hold kubelet kubeadm kubectl



### --------------------------------


echo Configurar os módulos de kernel necessários para o K8S/Containerd
cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
nf_nat
xt_REDIRECT
xt_owner
iptable_nat
iptable_mangle
iptable_filter
EOF
modprobe overlay
modprobe br_netfilter


### --------------------------------


echo Configurar alguns parâmetros do sistema para Containerd
cat << EOF | sudo tee /etc/sysctl.d/100-k8s.conf
kernel.shmall = 2097152
kernel.shmmax = 4294967295
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
fs.aio-max-nr = 1048576
fs.file-max = 6815744
EOF
sudo sysctl --system


### --------------------------------


echo Criar o arquivo de configuração do Containerd
mkdir -p /etc/containerd
sudo containerd config default | \
  sed 's/^\([[:space:]]*SystemdCgroup = \).*/\1true/' | \
  sudo tee /etc/containerd/config.toml


### --------------------------------


echo Confgurar auto complete Kubernetes
sudo apt-get install -y bash-completion
kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl
echo 'alias k=kubectl' | sudo tee -a /etc/bash.bashrc
echo 'complete -F __start_kubectl k' | sudo tee -a /etc/bash.bashrc


### --------------------------------


echo Mostrar os pacotes marcados para não atualizar
sudo apt-mark showhold
