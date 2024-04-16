# -*- mode: ruby -*-
# vi: set ft=ruby :

VM_IP_START = 10
VM_COUNT = 2

Vagrant.configure(2) do |config|

  config.vm.box = "boxomatic/debian-12"
  config.vm.box_version = "20240225.0.1"
  config.vm.box_check_update = false
  config.vm.provision "shell", path: "scripts/bootstrap.sh"
  config.vbguest.auto_update = false
  

  # Cria as VMs
  (1..VM_COUNT).each do |i|
      config.vm.define "node#{i}" do |node|
        node.vm.hostname = "node#{i}"
        node.vm.network "private_network", ip: "192.168.10.#{VM_IP_START + i}"
        node.vm.provider "virtualbox" do |v|
          v.name = "node#{i}"
          v.memory = 2048
          v.cpus = 2
        end

      # Configura /etc/hosts com IP de todos os nodes
      node.vm.provision "shell", 
        env: {
          "VM_COUNT" => VM_COUNT,
          "VM_IP_START" => VM_IP_START
        },
        inline: <<-SHELL
          for i in $(seq 1 $VM_COUNT); do echo 192.168.10.$((VM_IP_START + $i)) >> /etc/hosts ; done     
        SHELL
      end

  end


end
