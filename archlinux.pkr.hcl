source "qemu" "archlinux" {
  accelerator      = "kvm"
  boot_command     = ["arch<enter>arch<enter>", "curl -sfSLO http://{{ .HTTPIP }}:{{ .HTTPPort }}/pkglist.txt<enter><wait>"]
  boot_wait        = "15s"
  disk_image       = true
  disk_interface   = "virtio"
  format           = "qcow2"
  http_directory   = "./http"
  iso_checksum     = "file:https://mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-basic-20220401.51758.qcow2.SHA256"
  iso_url          = "https://mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-basic-20220401.51758.qcow2"
  net_device       = "virtio-net"
  shutdown_command = "sudo systemctl poweroff"
  ssh_password     = "arch"
  ssh_timeout      = "20m"
  ssh_username     = "arch"
  vm_name          = "golden-arch.qcow2"
}

build {
  sources = ["source.qemu.archlinux"]

  provisioner "shell" {
    inline = ["sudo pacman --sync --noconfirm --needed ansible"]
  }

  provisioner "ansible-local" {
    playbook_file = "./playbook.yml"
    extra_arguments = ["-v"]
  }
}