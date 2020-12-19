# k3os-vagrant

## build libvirt box with packer
```bash
sudo packer build ./template.json
```

## define network
```bash
sudo virsh net-define --file network.xml
```

## up box
```bash
sudo vagrant up
```
