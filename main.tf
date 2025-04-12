terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

variable "os_image" {
  default = "/var/lib/libvirt/images/ubuntu-22.04-server-cloudimg-amd64.img"
}

resource "libvirt_volume" "ubuntu_disk" {
  name   = "ubuntu-docker.qcow2"
  pool   = "default"
  source = var.os_image
  format = "qcow2"
  size   = 21474836480
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "cloudinit.iso"
  pool           = "default"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init/user-data.yaml")
}

data "template_file" "network_config" {
  template = file("${path.module}/cloud_init/network-config.yaml")
}

resource "libvirt_domain" "docker_vm" {
  name   = "docker-builder"
  memory = "4096"
  vcpu   = 2

  disk {
    volume_id = libvirt_volume.ubuntu_disk.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name = "default"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}

