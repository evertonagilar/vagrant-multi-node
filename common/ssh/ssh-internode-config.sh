#!/bin/sh

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
