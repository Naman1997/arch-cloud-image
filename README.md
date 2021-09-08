# arch-cloud-image

## Video Setup
Check out this [video](https://youtu.be/7FkfbxdQyt8) and follow along!

## How to create a cloud image for arch?

There are 2 ways to create a cloud image for arch
- Follow the instruction in this [repo](https://github.com/hartwork/image-bootstrap) and create an image from scratch
- Use a prebuilt image and configure it to have your custom settings

We will be following the 2nd way in this guide as its much faster

## Get the pre-built cloud image

- SSH into your proxmox node
- Download the latest arch cloud image from https://linuximages.de/openstack/arch/ to your proxmox node. You can find the reference to this link in this [repo](https://github.com/hartwork/image-bootstrap).
- `wget <YOUR_IMAGE_LINK>`
- This will download the qcow2 image in the current directory; **<IMAGE_NAME>**
- Create a VM in proxmox and note down its ID; **<VM_ID>**
- **Note** that the VM should have a CD with the **Arch ISO**. This should be configurable in the 'OS' section when creating the VM.


## Resize the disk[Optional]
You probably will want to increase the disk size and the partition size if you want a usable install. The base image has a 3G disk. I'll be adding +97G to that disk.
`qemu-img resize <IMAGE_NAME> +97G`

## Configure the template VM

- On your proxmox node run: `qm importdisk <VM_ID> <IMAGE_NAME> local-lvm`
- Go to the proxmox web console
- Go to the 'Hardware' section of your VM
- You will find an 'Unused Disk'on that VM. **Do not delete it.**
- Delete any 'Hard Disk' on that VM
- Edit that 'Unused Disk' and convert it to a 'Hard Disk'. I prefer to use 'VirtIO block' for 'Bus/Device'.
- Make sure that your template VM has the **Arch ISO CD** at the top of its boot order. You can check this in the 'Options' section of your VM. We want this so that we can `arch-chroot` in the image and configure our changes that we want to see on other VMs when we clone this template.
- Start the VM and boot into the live environment
- If you want to resize the partition and you have followed the *Resize the disk* section:
    - Resize your partitions using this guide: https://geekpeek.net/resize-filesystem-fdisk-resize2fs/
- Mount your drive that you added above by running `mount /dev/vdX /mnt`. You can check the drives with `lsblk`
- `arch-chroot /mnt`
- `useradd --create-home example_user`
- `passwd example_user`
- `usermod --append --groups wheel example_user`
- `sudo pacman -Syyy && sudo pacman -S vim`
- If you face any errors while installing vim, you might have to refresh your pacman keys
    - `pacman -S archlinux-keyring`
    - `pacman-key --refresh`
    - `pacman-key --populate`
    - Retry installing vim
- visudo
- Look for the wheel group and uncomment the line. It should look like:
```
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL) ALL
```
- Test your user
  - `su - example_user`
  - `sudo pacman -Syu`
- Poweroff the VM
- Change the boot order in the 'Options' section of your VM in proxmox console so that it now boots into the 'Hard Disk' that you created earlier.
- You should be able to ssh into the VM with your new user's password
- Install all the packages that you want in your example_user. Below are the packages that I install for my setup:
  - `wget https://raw.githubusercontent.com/Naman1997/arch-cloud-image/main/pkglist.txt`
  - `pacman -S --needed - < pkglist.txt`
- [Optional] Install my [zsh theme](https://github.com/Naman1997/Terminal-themes/tree/main/zsh)
- [Optional] Setup qemu-guest agent
    - `pacman -S qemu-guest-agent`
    - `systemctl start qemu-guest-agent`
    - `systemctl enable qemu-guest-agent`

## Use this VM as a cloud-init image for terraform
The great thing about this setup is that you do not *need* to convert this VM into a proxmox template. You can clone this VM directly and keep on updating this VM and all clones will have the same updated image!

To use this VM as a cloud-init template follow these steps:
- Navigate to the 'Hardware' section of your template VM
- Click on Add > CloudInit Drive
- Now navigate to 'Cloud-Init' section of your template VM
- Edit the config here to have your newly created user **OR** use the user already present in the cloud image. User already present in the image is called **arch**
- Don't add Password as you can login using SSH keys and use sudo without password. If you do set password here though, you might need to reset it after cloning finishes.
- Add your SSH public keys and configure IP Config to use IPv4 and DHCP
- Click on 'Regenerate Image'

Your image is now ready! 
Check out this [repo](https://github.com/Naman1997/proxmox-terraform-template-k8s) to use a terraform script for creating VMs for a k8s cluster using this image!

**Note:** If you follow the repo mentioned above, please make sure to also install [yay](https://github.com/Jguer/yay)
