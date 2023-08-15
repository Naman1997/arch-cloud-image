## Create the golden image

The following commands will create a qcow2 image at 'output-archlinux/golden-arch.qcow2'

```
git clone https://github.com/Naman1997/arch-cloud-image.git
cd arch-cloud-image/
packer init archlinux.pkr.hcl
chmod +x scripts/create.sh
# Update CLOUD_USER here
./scripts/create.sh CLOUD_USER
```

```
# EXAMPLE
# ./scripts/create.sh arch
```

## Create a proxmox template using the created image [Optional]
The following commands will create a template with VM ID 9000.
WARNING: If a VM/Template has ID 9000, then these commands will destroy and replace it with the golden image template for proxmox.
```
chmod +x scripts/proxmox.sh
# Update variables here
./scripts/proxmox.sh PROXMOX_USERNAME PROXMOX_IP CLOUD_USER PATH_TO_PUB_KEY
```

```
# EXAMPLE
# ./scripts/proxmox.sh root 192.168.0.106 arch ~/.ssh/id_rsa.pub
```