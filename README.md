# arch-cloud-image

[![Validatate configs](https://github.com/Naman1997/arch-cloud-image/actions/workflows/validate.yml/badge.svg)](https://github.com/Naman1997/arch-cloud-image/actions/workflows/validate.yml)
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/Naman1997/arch-cloud-image/blob/main/LICENSE)

## Objective of this repo
To create a qcow2 template that is modified to contain certain programs. This is sometimes also referred to as a [golden image](https://opensource.com/article/19/7/what-golden-image). This image also contains my [zsh config](https://github.com/Naman1997/Terminal-themes/tree/main/zsh) for a specified user. This means that a user is created and a list of programs are installed on top of the latest [official cloud image](https://wiki.archlinux.org/title/Arch_Linux_on_a_VPS#Official_Arch_Linux_cloud_image) provided by the arch linux community.

## Prerequisites
- [packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
- [jq](https://stedolan.github.io/jq/)

## Usage

This repo uses the [playbook.yml](https://github.com/Naman1997/arch-cloud-image/blob/main/playbook.yml) file in the root directory to create the golden image. In case you want to install any additional tools or make any changes, make sure to modify that file. The playbook installs a list of packages that are present in the [pkglist.txt](https://github.com/Naman1997/arch-cloud-image/blob/version/http/pkglist.txt) file that you can modify as well.

The following command will create a qcow2 image at 'output-archlinux/golden-arch.qcow2' and create a template with VM ID 9000.
This command assumes that you'll be using the same public key to ssh into the proxmox node as well as the VMs created by the template to keep things simple. 

WARNING: If a VM/Template has ID 9000, then these commands will destroy and replace it with the golden image template for proxmox.

```
make -s template \
    CLOUD_USER=<your_cloud_user> \
    PROXMOX_USERNAME=<your_proxmox_username> \
    PROXMOX_IP=<your_proxmox_ip> \
    PATH_TO_PUB_KEY=<your_path_to_pub_key>
```
```
#Example [Make sure you're able to ssh in the proxmox node using the key provided here]
make -s template \
    CLOUD_USER=arch \
    PROXMOX_USERNAME=root \
    PROXMOX_IP=192.168.0.100 \
    PATH_TO_PUB_KEY=~/.ssh/id_rsa.pub
```

To use the created template [ID 9000], create a clone using it and attempt to ssh into the VM using user as CLOUD_USER.

## Cleanup

The following command will delete the qcow2 file and reset the user-data file used to generate the template.

```
make clean
```

## Older way of doing the same thing

You can find the shell scripts and their usage [here](SCRIPTS.md).

## Video
[Follow along](https://www.youtube.com/watch?v=FjLkzwdgUiM&t=216s) as I create the image and use it to deploy a virtual machine on proxmox!
