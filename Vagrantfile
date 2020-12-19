# -*- mode: ruby -*-
# vi: set ft=ruby :

def ip2mac(prefix, str_ip)
	@mac=prefix
	str_ip.split('.').each do |k|
		k="%02x" % k
		@mac=@mac+":"+k.to_s
	end
	return @mac
end

Vagrant.configure("2") do |config|
 (11..11).each do |i|
    config.vm.define "k3os#{i}" do |node|
      node.ssh.username = 'rancher'
      node.ssh.password = 'vagrant'
      node.ssh.insert_key = false
      node.vm.box = 'k3os'
      node.vm.guest = 'linux'
      node.vm.hostname = "k3os#{i}"
      node.vm.synced_folder '.', '/vagrant', disabled: true
      node.vm.provider :libvirt do |domain|
        domain.driver = 'kvm'
        domain.memory = 4096
        domain.cpus = 4
        domain.nested = true
        domain.management_network_name = "k3os"
        domain.management_network_address = "10.5.8.0/24"
        domain.management_network_mac = ip2mac("50:50","10.5.8.#{i}")
        domain.storage :file, :size => '200G', :bus => 'virtio'
        domain.storage :file, :size => '100G', :bus => 'virtio'
      end
      node.vm.provision 'shell',
      upload_path: '/home/rancher/vagrant-shell',
      inline: <<-SHELL
      mkdir -p /mnt
      mount /dev/vda1 /mnt
      cat > /mnt/k3os/system/config.yaml <<EOF
hostname: "k3os#{i}"
k3os:
  modules:
    - kvm
    - vhost-net
  dns_nameservers:
    - 223.5.5.5
    - 8.8.8.8
  token: vagrant
  password: vagrant
  k3s_args:
    - server
EOF
reboot
SHELL
    end
  end
end

Vagrant.configure("2") do |config|
(12..13).each do |i|
    config.vm.define "k3os#{i}" do |node|
      node.ssh.username = 'rancher'
      node.ssh.password = 'vagrant'
      node.ssh.insert_key = false
      node.vm.box = 'k3os'
      node.vm.guest = 'linux'
      node.vm.hostname = "k3os#{i}"
      node.vm.synced_folder '.', '/vagrant', disabled: true
      node.vm.provider :libvirt do |domain|
        domain.driver = 'kvm'
        domain.memory = 4096
        domain.cpus = 4
        domain.nested = true
        domain.management_network_name = "k3os"
        domain.management_network_address = "10.5.8.0/24"
        domain.management_network_mac = ip2mac("50:50","10.5.8.#{i}")
        domain.storage :file, :size => '200G', :bus => 'virtio'
        domain.storage :file, :size => '100G', :bus => 'virtio'
      end
      node.vm.provision 'shell',
      upload_path: '/home/rancher/vagrant-shell',
      inline: <<-SHELL
      mkdir -p /mnt
      mount /dev/vda1 /mnt
      cat > /mnt/k3os/system/config.yaml <<EOF
hostname: "k3os#{i}"
k3os:
  modules:
    - kvm
    - vhost-net
  dns_nameservers:
    - 223.5.5.5
    - 8.8.8.8
  token: vagrant
  password: vagrant
  k3s_args:
    - agent
  server_url: https://10.5.8.11:6443
EOF
reboot
SHELL
    end
  end
end
