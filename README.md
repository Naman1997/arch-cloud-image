# arch-cloud-image

## Objective of this repo
To create a qcow2 template that is modified to contain certain programs. This is sometimes also referred to as a [golden image](https://opensource.com/article/19/7/what-golden-image). This image also contains my [zsh config](https://github.com/Naman1997/Terminal-themes/tree/main/zsh) for a specified user. This means that a user is created and a list of programs are installed on top of the latest [official cloud image](https://wiki.archlinux.org/title/Arch_Linux_on_a_VPS#Official_Arch_Linux_cloud_image) provided by the arch linux community.

## Prerequisites
- [packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)

## Create the golden image

The following commands will create a qcow2 image at 'output-archlinux/golden-arch.qcow2'

```
git clone https://github.com/Naman1997/arch-cloud-image.git
cd arch-cloud-image/
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

To use the created template [ID 9000], create a clone using it and attempt to ssh into the VM using user as CLOUD_USER