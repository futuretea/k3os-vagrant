#!/bin/bash


mkdir -p /mnt
mount /dev/vda1 /mnt
cat > /mnt/k3os/system/config.yaml <<EOF
write_files:
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
