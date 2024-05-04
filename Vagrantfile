# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_PASSWD_ROOT="teste"
VM_CONTROLPLANE_COUNT = 2
VM_WORKER_COUNT = 2
VM_COUNT = VM_CONTROLPLANE_COUNT + VM_WORKER_COUNT
VM_IP_SUFIX = "192.168.10"
VM_IP_START = 10
VM_MASTER_BASE_NAME = "vm-controlplane"
VM_WORKER_BASE_NAME = "vm-worker"
VM_VIRTUAL_IP = "#{VM_IP_SUFIX}.#{VM_IP_START}"
VM_DNS_PREFIX = "kubernetes.local"
VM_DNS_VIRTUAL_IP = "controlplane"
VM_BOX = "boxomatic/debian-12"
VM_BOX_VERSION = "20240225.0.1"
VM_K8S_VERSION = "1.29.4-2.1"
VM_CONTROL_PLANE_ENDPOINT = "#{VM_DNS_VIRTUAL_IP}.#{VM_DNS_PREFIX}:6443"
VM_POD_NETWORK_CIDR = "10.244.0.0/16"
VM_SERVICE_CIDR = "10.96.0.0/12"
VM_CALICO_VERSION = "v3.27.1"

Vagrant.configure(2) do |config|
  config.vm.box = "#{VM_BOX}"
  config.vm.box_version = "#{VM_BOX_VERSION}"
  config.vm.box_check_update = false
  config.vbguest.auto_update = false
  
  # Cria as VMs control-plane
  (1..VM_CONTROLPLANE_COUNT).each do |i|
    hostname = "#{VM_MASTER_BASE_NAME}#{i}"
    ip = "#{VM_IP_SUFIX}.#{VM_IP_START + i}"
    controlplaneNumber = i
    vrrpPrioridade = 100 - controlplaneNumber
    vrrpType = controlplaneNumber == 1 ? "MASTER" : "BACKUP"
    config.vm.define hostname do |node|
      node.vm.provider "virtualbox" do |v|
        v.name = hostname
        v.memory = 2048
        v.cpus = 2
      end
      node.vm.hostname = hostname
      node.vm.network "private_network", ip: ip
      node.vm.provision "file", source: "scripts", destination: "~/scripts"
      node.vm.provision "file", source: "config", destination: "~/config"
      node.vm.provision "shell",
        env: {
              "VM_PASSWD_ROOT" => VM_PASSWD_ROOT,
              "VM_BOX" => VM_BOX,
              "VM_BOX_VERSION" => VM_BOX_VERSION,
              "VM_CONTROLPLANE_COUNT" => VM_CONTROLPLANE_COUNT,
              "VM_CONTROLPLANE_NUMBER" => controlplaneNumber,
              "VM_CONTROL_PLANE_ENDPOINT" => VM_CONTROL_PLANE_ENDPOINT,
              "VM_POD_NETWORK_CIDR" => VM_POD_NETWORK_CIDR,
              "VM_SERVICE_CIDR" => VM_SERVICE_CIDR,
              "VM_COUNT" => VM_COUNT,
              "VM_TYPE" => "controlplane",
              "VM_IP_START" => VM_IP_START,
              "VM_IP_SUFIX" => VM_IP_SUFIX,
              "VM_MASTER_BASE_NAME" => VM_MASTER_BASE_NAME,
              "VM_WORKER_BASE_NAME" => VM_WORKER_BASE_NAME,
              "VM_HOSTNAME" => hostname,
              "VM_IP" => ip,
              "VM_DNS_PREFIX" => VM_DNS_PREFIX,
              "VM_VIRTUAL_IP" => VM_VIRTUAL_IP,
              "VM_DNS_VIRTUAL_IP" => VM_DNS_VIRTUAL_IP,
              "VM_VRRP_PRIORIDADE" => vrrpPrioridade,
              "VM_VRRP_TYPE" => vrrpType,
              "VM_K8S_VERSION" => VM_K8S_VERSION,
              "VM_CALICO_VERSION" => VM_CALICO_VERSION
            }, path: "scripts/bootstrap.sh"
    end
  end
end
