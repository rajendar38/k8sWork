# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # Kubernetes Master Server
  config.vm.define "kmastercent" do |node|
  
    node.vm.box               = "centos/7"
    node.vm.box_check_update  = false
    node.vm.box_version       = "2004.01"
    node.vm.hostname          = "kmastercent.example.com"

    node.vm.network "private_network", ip: "172.16.16.100"
  
    node.vm.provider :virtualbox do |v|
      v.name    = "kmastercent"
      v.memory  = 2048
      v.cpus    =  2
    end
  
    node.vm.provider :libvirt do |v|
      v.memory  = 2048
      v.nested  = true
      v.cpus    = 2
    end
  
    node.vm.provision "shell", path: "bootstrap_kmaster.sh"
  
  end


  # Kubernetes Worker Nodes
  NodeCount = 1

  (1..NodeCount).each do |i|

    config.vm.define "kworkercent#{i}" do |node|

      node.vm.box               = "centos/7"
      node.vm.box_check_update  = false
      node.vm.box_version       = "2004.01"
      node.vm.hostname          = "kworkercent#{i}.example.com"

      node.vm.network "private_network", ip: "172.16.16.10#{i}"

      node.vm.provider :virtualbox do |v|
        v.name    = "kworkercent#{i}"
        v.memory  = 1024
        v.cpus    = 1
      end

      node.vm.provider :libvirt do |v|
        v.memory  = 1024
        v.nested  = true
        v.cpus    = 1
      end

      node.vm.provision "shell", path: "bootstrap_kworker.sh"

    end

  end

end
