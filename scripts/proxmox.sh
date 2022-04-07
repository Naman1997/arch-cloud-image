#!/bin/bash
ssh -q -o BatchMode=yes $1@$2 exit

if [ $? != "0" ]; then
    echo "SSH connection failed!"
    exit 0
fi

ssh -q -o BatchMode=yes $1@$2 "mkdir -p packer-template"
scp output-archlinux/golden-arch.qcow2 $1@$2:packer-template/
scp $4 $1@$2:packer-template/
basename=`basename $4`

ssh -T $1@$2 /bin/bash <<ENDSSH
    qm destroy 9000
    sleep 3
    qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 --agent 1
    qm importdisk 9000 packer-template/golden-arch.qcow2 local-lvm
    qm set 9000 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-9000-disk-0,cache=writeback,discard=on
    qm set 9000 --boot c --bootdisk scsi0
    qm set 9000 --ide2 local-lvm:cloudinit
    qm set 9000 --ciuser $3 --citype nocloud --ipconfig0 ip=dhcp
    qm set 9000 --sshkeys 'packer-template/$basename'
    qm set 9000 --name arch-golden --template 1
ENDSSH