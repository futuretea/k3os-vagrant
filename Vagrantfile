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
        domain.memory = 8192
        domain.cpus = 8
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
boot_cmd:
- rc-update add k3s-restarter.service
write_files:
- content: |
    #!/usr/bin/env bash

    echo "\\\$\\\$" >/var/run/k3s-restarter-trap.pid
    handler(){
      sleep 5
      /etc/init.d/k3s-service restart
    }
    trap handler SIGHUP
    tail -f /dev/null & wait \\\$!
  path: /opt/k3s-restarter
  owner: root
  permissions: '0755'
- content: |
    #!/sbin/openrc-run

    supervisor=supervise-daemon
    name="k3s-restarter"
    command="/opt/k3s-restarter"
    command_args=">/var/log/k3s-restarter.log 2>&1"

    output_log=/var/log/k3s-restarter.log
    error_log=/var/log/k3s-restarter.log

    pidfile="/var/run/k3s-restarter.pid"
    respawn_delay=5
    respawn_max=0
  path: /etc/init.d/k3s-restarter.service
  owner: root
  permissions: '0755'
- content: |
    options kvm ignore_msrs=1
  path: /etc/modprobe.d/kvm.conf
  owner: root
  permissions: ''
k3os:
  modules:
    - kvm
    - vhost_net
  dns_nameservers:
    - 223.5.5.5
    - 8.8.8.8
  ntpServers:
    - ntp.ubuntu.com
  token: vagrant
  password: vagrant
  k3s_args:
    - server
    - --cluster-init
    - --disable
    - local-storage
  labels:
    svccontroller.k3s.cattle.io/enablelb: true
EOF
umount /mnt
sudo rc-service ccapply restart
sudo rc-service sshd restart
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
        domain.memory = 8192
        domain.cpus = 8
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
boot_cmd:
- rc-update add k3s-restarter.service
write_files:
- content: |
    #!/usr/bin/env bash

    echo "\\\$\\\$" >/var/run/k3s-restarter-trap.pid
    handler(){
      sleep 5
      /etc/init.d/k3s-service restart
    }
    trap handler SIGHUP
    tail -f /dev/null & wait \\\$!
  path: /opt/k3s-restarter
  owner: root
  permissions: '0755'
- content: |
    #!/sbin/openrc-run

    supervisor=supervise-daemon
    name="k3s-restarter"
    command="/opt/k3s-restarter"
    command_args=">/var/log/k3s-restarter.log 2>&1"

    output_log=/var/log/k3s-restarter.log
    error_log=/var/log/k3s-restarter.log

    pidfile="/var/run/k3s-restarter.pid"
    respawn_delay=5
    respawn_max=0
  path: /etc/init.d/k3s-restarter.service
  owner: root
  permissions: '0755'
- content: |
    options kvm ignore_msrs=1
  path: /etc/modprobe.d/kvm.conf
  owner: root
  permissions: ''
k3os:
  modules:
    - kvm
    - vhost_net
  dns_nameservers:
    - 223.5.5.5
    - 8.8.8.8
  ntpServers:
    - ntp.ubuntu.com
  token: vagrant
  password: vagrant
  k3s_args:
    - agent
  server_url: https://10.5.8.11:6443
EOF
umount /mnt
sudo rc-service ccapply restart
sudo rc-service sshd restart
SHELL
    end
  end
end
