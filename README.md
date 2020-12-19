# k3os-vagrant

## build box
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
