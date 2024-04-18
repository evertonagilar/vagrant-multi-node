# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_CONTROLPLANE_COUNT = 2
VM_WORKER_COUNT = 2
VM_COUNT = VM_CONTROLPLANE_COUNT + VM_WORKER_COUNT
VM_IP_SUFIX = "192.168.10"
VM_IP_START = 10
VM_NAME_SUFIX = "node"
VM_VIRTUAL_IP = "#{VM_IP_SUFIX}.#{VM_IP_START}"
VM_DNS_PREFIX = "kubernetes.local"
VM_DNS_CONTROL_PLANE = "controlplane.#{VM_DNS_PREFIX}"
VM_BOX = "boxomatic/debian-12"
VM_BOX_VERSION = "20240225.0.1"

Vagrant.configure(2) do |config|
  config.vm.box = "#{VM_BOX}"
  config.vm.box_version = "#{VM_BOX_VERSION}"
  config.vm.box_check_update = false
  config.vbguest.auto_update = false
  
  # Cria as VMs control-plane
  (1..VM_CONTROLPLANE_COUNT).each do |i|
    hostname = "#{VM_NAME_SUFIX}#{i}"
    ip = "#{VM_IP_SUFIX}.#{VM_IP_START + i}"
    config.vm.define "#{hostname}" do |node|
      node.vm.hostname = "#{hostname}"
      node.vm.network "private_network", ip: "#{ip}"
      node.vm.provider "virtualbox" do |v|
        v.name = "#{hostname}"
        v.memory = 2048
        v.cpus = 2
      end

      # Executar script de bootstrap  
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
          "VM_NAME_SUFIX" => VM_NAME_SUFIX,
          "VM_HOSTNAME" => hostname,
          "VM_IP" => ip,
          "VM_VIRTUAL_IP" => VM_VIRTUAL_IP,
          "VM_DNS_PREFIX" => VM_DNS_PREFIX,
          "VM_DNS_CONTROL_PLANE" => VM_DNS_CONTROL_PLANE
        }, path: "scripts/bootstrap.sh"
    end
  end
end
