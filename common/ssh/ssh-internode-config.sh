#!/bin/sh

echo 'Cadastrar variáveis prefixo VM_ em /etc/environment'
vm_variables=$(env | grep -E '^VM_')
for vm_variable in "${vm_variables[@]}"; do
  vm_variable_name=${vm_variable%%=*}
  vm_variable_value=${vm_variable#*=}
  echo "$vm_variable_name=$vm_variable_value" | tee -a /etc/environment
done

echo ETCDCTL_API=$ETCDCTL_API | tee -a /etc/environment

### --------------------------------

echo 'Cadastrar máquinas virtuais em /etc/hosts'
echo "$VM_VIRTUAL_IP $VM_DNS_VIRTUAL_IP $VM_DNS_VIRTUAL_IP.${VM_DNS_PREFIX}" >> /etc/hosts
for i in $(seq 1 $VM_CONTROLPLANE_COUNT); do
    node="${VM_MASTER_BASE_NAME}${i}"
    node_fqdn="${node}.${VM_DNS_PREFIX}"
    ip="${VM_IP_SUFIX}.$((VM_IP_CONTROLPLANE_START + i))"
    echo "$ip ${node} ${node_fqdn}" >> /etc/hosts
done
for i in $(seq 1 $VM_WORKER_COUNT); do
    node="${VM_WORKER_BASE_NAME}${i}"
    node_fqdn="${node}.${VM_DNS_PREFIX}"
    ip="${VM_IP_SUFIX}.$((VM_IP_WORKER_START + i))"
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

echo 'Comentar parâmetro MaxAuthTries'
sed -i \
  's/^MaxAuthTries.*/#MaxAuthTries 10/' \
  /etc/ssh/sshd_config


### --------------------------------

echo 'Criar arquivo configuração /home/vagrant/.ssh/config'
cat << EOF >> /home/vagrant/.ssh/config
Host vm-*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF
chmod 600 /home/vagrant/.ssh/config


### --------------------------------


echo 'Criar arquivo configuração /root/.ssh/config'
cat << EOF >> /root/.ssh/config
Host vm-*
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOF
chmod 600 /root/.ssh/config


### --------------------------------

echo "Config internode vagrant: Copiando chave privada e pública para /home/vagrant/.ssh/"
cp "common/ssh/k8s-multinode" "common/ssh/k8s-multinode.pub" /home/vagrant/.ssh/
cat "common/ssh/k8s-multinode.pub" >> /home/vagrant/.ssh/authorized_keys
ln -s /home/vagrant/.ssh/k8s-multinode /home/vagrant/.ssh/id_rsa
ln -s /home/vagrant/.ssh/k8s-multinode.pub /home/vagrant/.ssh/id_rsa.pub
chmod 600 /home/vagrant/.ssh/k8s-multinode
chmod 644 /home/vagrant/.ssh/k8s-multinode.pub
chown -R vagrant:vagrant /home/vagrant/.ssh

### --------------------------------

echo "Config internode root: Copiando chave privada e pública para /root/.ssh/"
cp "common/ssh/k8s-multinode" "common/ssh/k8s-multinode.pub" /root/.ssh/
cat "common/ssh/k8s-multinode.pub" >> /root/.ssh/authorized_keys
ln -s /root/.ssh/k8s-multinode /root/.ssh/id_rsa
ln -s /root/.ssh/k8s-multinode.pub /root/.ssh/id_rsa.pub


### --------------------------------

echo 'Reload sshd'
systemctl reload sshd


### --------------------------------


echo 'Senha padrão do root: admin'
echo -e "admin\admin" | passwd root >/dev/null 2>&1
