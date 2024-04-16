# -*- mode: ruby -*-
# vi: set ft=ruby :

IP_START = 1

Vagrant.configure(2) do |config|

  config.vm.box = "boxomatic/debian-12"
  config.vm.box_version = "20240225.0.1"
  config.vm.box_check_update = false
  config.vbguest.auto_update = false
  config.vm.provision "shell", path: "bootstrap.sh"

  Count = 2

  # Cria as VMs
  (1..Count).each do |i|
      config.vm.define "node#{i}" do |node|
        node.vm.hostname = "node#{i}"
        node.vm.network "private_network", ip: "192.168.10.#{IP_START + i}"
        node.vm.provider "virtualbox" do |v|
          v.name = "node#{i}"
          v.memory = 2048
          v.cpus = 2
      end
    end
  end

end
