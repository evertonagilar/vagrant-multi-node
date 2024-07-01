#!/bin/bash
#
# Instalar o software do Kubernetes
#
#
#######################################################################


# Variáveis

echo
echo "Versão do Kubernetes: $VM_K8S_VERSION"
echo "Versão do ContainerD: $VM_CONTAINERD_VERSION"
echo

### --------------------------------

echo ETCDCTL_API=$ETCDCTL_API | tee -a /etc/environment

### --------------------------------

echo 'Desabilitar o swap'
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab



### --------------------------------


echo 'Adicionar a chave do repositório APT do Kubernetes'
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg


echo 'Adicionar o repositório APT do Kubernetes'
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list


### --------------------------------


echo 'Adicionar a chave do repositório APT do containerd'
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo 'Adicionar o repositório APT do containerd'
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null


### --------------------------------


echo 'Atualizar repositório apt'
apt update


### --------------------------------


echo 'Instalar Containerd'
apt install -y containerd.io=$VM_CONTAINERD_VERSION

echo 'Marcar para não atualizar containerd.io junto com o apt upgrade'
apt-mark hold containerd.io


### --------------------------------


echo "Instalar ferramentas Kubernetes"
apt install -y kubelet=$VM_K8S_VERSION kubeadm=$VM_K8S_VERSION kubectl=$VM_K8S_VERSION


echo 'Marcar para não atualizar Kubernetes junto com o apt upgrade'
apt-mark hold kubelet kubeadm kubectl



### --------------------------------


echo 'Instalação dos módulos do Linux Kernel'
cat << EOF | tee /etc/modules-load.d/k8s.conf
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


echo 'Configurar sysctl para o Kubernetes'
cat << EOF | tee /etc/sysctl.d/100-k8s.conf
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
sysctl --system


### --------------------------------


echo 'Criar o arquivo de configuração do Containerd'
mkdir -p /etc/containerd
containerd config default | \
  sed 's/^\([[:space:]]*SystemdCgroup = \).*/\1true/' | \
  tee /etc/containerd/config.toml

### --------------------------------

echo 'Reiniciar o Containerd'
systemctl restart containerd

### --------------------------------


echo 'Configurar auto complete Kubernetes'
apt-get install -y bash-completion
mkdir -p /etc/bash_completion.d
kubectl completion bash > /etc/bash_completion.d/kubectl
cat << EOF >> /etc/bash.bashrc
source /usr/share/bash-completion/bash_completion
source /etc/bash_completion
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF


### --------------------------------


echo 'Criar arquivo de configuração /etc/crictl.yaml'
cat << EOF >> /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 2
debug: false
pull-image-on-create: false
EOF


### --------------------------------


echo 'Mostrar os pacotes marcados que NÂO deve atualizar'
apt-mark showhold


### --------------------------------

echo 'Configura KUBELET_EXTRA_ARGS para o kubelet'
echo "KUBELET_EXTRA_ARGS=\"--node-ip=$VM_IP --container-runtime-endpoint=unix:///run/containerd/containerd.sock\"" >> /etc/default/kubelet


### --------------------------------

echo 'Baixar as imagens do Kubernetes'
kubeadm config images pull --cri-socket unix:///run/containerd/containerd.sock


### --------------------------------

echo 'Habilitar o containerd e o kubelet'
systemctl enable --now containerd
systemctl enable kubelet
systemctl restart kubelet

