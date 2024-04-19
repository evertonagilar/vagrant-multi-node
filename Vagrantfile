# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_CONTROLPLANE_COUNT = 2
VM_WORKER_COUNT = 2
VM_COUNT = VM_CONTROLPLANE_COUNT + VM_WORKER_COUNT
VM_IP_SUFIX = "192.168.10"
VM_IP_START = 10
VM_MASTER_NODE_NAME = "vm-master"
VM_WORKER_NODE_NAME = "vm-worker"
VM_VIRTUAL_IP = "#{VM_IP_SUFIX}.#{VM_IP_START}"
VM_DNS_PREFIX = "kubernetes.local"
VM_DNS_VIRTUAL_IP = "controlplane"
VM_BOX = "boxomatic/debian-12"
VM_BOX_VERSION = "20240225.0.1"
VM_K8S_VERSION="1.29.3-1.1"

Vagrant.configure(2) do |config|
  config.vm.box = "#{VM_BOX}"
  config.vm.box_version = "#{VM_BOX_VERSION}"
  config.vm.box_check_update = false
  config.vbguest.auto_update = false
  
  # Cria as VMs control-plane
  (1..VM_CONTROLPLANE_COUNT).each do |i|
    VM_HOSTNAME = "#{VM_MASTER_NODE_NAME}#{i}"
    VM_IP = "#{VM_IP_SUFIX}.#{VM_IP_START + i}"
    VM_CONTROLPLANE_NUMBER = i
    VM_VRRP_PRIORIDADE = 100 + VM_CONTROLPLANE_NUMBER
    VM_VRRP_TYPE_INSTANCE = "MASTER"
    if VM_CONTROLPLANE_NUMBER > 1
        VM_VRRP_TYPE_INSTANCE = "BACKUP"
    end
    config.vm.define "#{VM_HOSTNAME}" do |node|
      node.vm.hostname = "#{VM_HOSTNAME}"
      node.vm.network "private_network", ip: "#{VM_IP}"
      node.vm.provider "virtualbox" do |v|
        v.name = "#{VM_HOSTNAME}"
        v.memory = 2048
        v.cpus = 2
      end

      node.vm.provision "shell",
        env: {
          "VM_BOX" => VM_BOX,
          "VM_BOX_VERSION" => VM_BOX_VERSION,
          "VM_CONTROLPLANE_COUNT" => VM_CONTROLPLANE_COUNT,
          "VM_CONTROLPLANE_NUMBER" => i,
          "VM_COUNT" => VM_COUNT,
          "VM_TYPE" => "controlplane",
          "VM_IP_START" => VM_IP_START,
          "VM_IP_SUFIX" => VM_IP_SUFIX,
          "VM_MASTER_NODE_NAME" => VM_MASTER_NODE_NAME,
          "VM_WORKER_NODE_NAME" => VM_WORKER_NODE_NAME,
          "VM_HOSTNAME" => VM_HOSTNAME,
          "VM_DNS_PREFIX" => VM_DNS_PREFIX,
          "VM_IP" => VM_IP,
          "VM_VIRTUAL_IP" => VM_VIRTUAL_IP,
          "VM_DNS_VIRTUAL_IP" => VM_DNS_VIRTUAL_IP,
          "VM_VRRP_PRIORIDADE" => VM_VRRP_PRIORIDADE,
          "VM_VRRP_TYPE_INSTANCE" => VM_VRRP_TYPE_INSTANCE,
          "VM_K8S_VERSION" => VM_K8S_VERSION
        }, path: "scripts/common.sh"
      node.vm.provision "shell",
          env: {
            "VM_BOX" => VM_BOX,
            "VM_BOX_VERSION" => VM_BOX_VERSION,
            "VM_CONTROLPLANE_COUNT" => VM_CONTROLPLANE_COUNT,
            "VM_CONTROLPLANE_NUMBER" => i,
            "VM_COUNT" => VM_COUNT,
            "VM_TYPE" => "controlplane",
            "VM_IP_START" => VM_IP_START,
            "VM_IP_SUFIX" => VM_IP_SUFIX,
            "VM_MASTER_NODE_NAME" => VM_MASTER_NODE_NAME,
            "VM_WORKER_NODE_NAME" => VM_WORKER_NODE_NAME,
            "VM_HOSTNAME" => VM_HOSTNAME,
            "VM_DNS_PREFIX" => VM_DNS_PREFIX,
            "VM_IP" => VM_IP,
            "VM_VIRTUAL_IP" => VM_VIRTUAL_IP,
            "VM_DNS_VIRTUAL_IP" => VM_DNS_VIRTUAL_IP,
            "VM_VRRP_PRIORIDADE" => VM_VRRP_PRIORIDADE,
            "VM_VRRP_TYPE_INSTANCE" => VM_VRRP_TYPE_INSTANCE,
            "VM_K8S_VERSION" => VM_K8S_VERSION
          },
          path: "scripts/k8s.sh"
      node.vm.provision "shell",
        env: {
          "VM_BOX" => VM_BOX,
          "VM_BOX_VERSION" => VM_BOX_VERSION,
          "VM_CONTROLPLANE_COUNT" => VM_CONTROLPLANE_COUNT,
          "VM_CONTROLPLANE_NUMBER" => i,
          "VM_COUNT" => VM_COUNT,
          "VM_TYPE" => "controlplane",
          "VM_IP_START" => VM_IP_START,
          "VM_IP_SUFIX" => VM_IP_SUFIX,
          "VM_MASTER_NODE_NAME" => VM_MASTER_NODE_NAME,
          "VM_WORKER_NODE_NAME" => VM_WORKER_NODE_NAME,
          "VM_HOSTNAME" => VM_HOSTNAME,
          "VM_DNS_PREFIX" => VM_DNS_PREFIX,
          "VM_IP" => VM_IP,
          "VM_VIRTUAL_IP" => VM_VIRTUAL_IP,
          "VM_DNS_VIRTUAL_IP" => VM_DNS_VIRTUAL_IP,
          "VM_VRRP_PRIORIDADE" => VM_VRRP_PRIORIDADE,
          "VM_VRRP_TYPE_INSTANCE" => VM_VRRP_TYPE_INSTANCE,
          "VM_K8S_VERSION" => VM_K8S_VERSION
        },
        path: "scripts/keepalived.sh"

    end
  end
end
