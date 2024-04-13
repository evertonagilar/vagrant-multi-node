# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"
  config.vm.box = "bento/debian-12"
  config.vm.box_version = "202401.31.0"
  config.vm.box_check_update = false

  Count = 3

  # Cria as VMs
  (1..Count).each do |i|
      config.vm.define "node#{i}" do |node|
        node.vm.hostname = "node#{i}"
        node.vm.network "private_network", ip: "192.168.10.10#{i}"
        node.vm.provider "virtualbox" do |v|
          v.name = "node#{i}"
          v.memory = 2048
          v.cpus = 2
      end
    end
  end

end
