# arch-cloud-image

[![Ansible](https://github.com/Naman1997/arch-cloud-image/actions/workflows/ansible.yml/badge.svg)](https://github.com/Naman1997/arch-cloud-image/actions/workflows/ansible.yml)
[![Packer](https://github.com/Naman1997/arch-cloud-image/actions/workflows/packer.yml/badge.svg)](https://github.com/Naman1997/arch-cloud-image/actions/workflows/packer.yml)
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/Naman1997/arch-cloud-image/blob/main/LICENSE)

## Objective of this repo
To create a qcow2 template that is modified to contain certain programs. This is sometimes also referred to as a [golden image](https://opensource.com/article/19/7/what-golden-image). This image also contains my [zsh config](https://github.com/Naman1997/Terminal-themes/tree/main/zsh) for a specified user. This means that a user is created and a list of programs are installed on top of the latest [official cloud image](https://wiki.archlinux.org/title/Arch_Linux_on_a_VPS#Official_Arch_Linux_cloud_image) provided by the arch linux community.

## Prerequisites
- [packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
- [jq](https://stedolan.github.io/jq/)

## Usage

You can either create the image locally first with:

```
make -s image CLOUD_USER=<your_cloud_user>
```
```
#Example
make -s image CLOUD_USER=arch
```

Or you can make the image and create a template using 1 command with:

```
make -s template \
    CLOUD_USER=<your_cloud_user> \
    PROXMOX_USERNAME=<your_proxmox_username> \
    PROXMOX_IP=<your_proxmox_ip> \
    PATH_TO_PUB_KEY=<your_path_to_pub_key>
```
```
#Example
make -s template \
    CLOUD_USER=arch \
    PROXMOX_USERNAME=root \
    PROXMOX_IP=192.168.0.100 \
    PATH_TO_PUB_KEY=~/.ssh/id_rsa.pub
```

You can find the older shell scripts and their usage [here](SCRIPTS.md).

To use the created template [ID 9000], create a clone using it and attempt to ssh into the VM using user as CLOUD_USER.

## Video
[Follow along](https://www.youtube.com/watch?v=FjLkzwdgUiM&t=216s) as I create the image and use it to deploy a virtual machine on proxmox!
