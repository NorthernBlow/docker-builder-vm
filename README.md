![Terraform](https://img.shields.io/badge/terraform-v1.7+-623CE4?logo=terraform&logoColor=white)
![Libvirt](https://img.shields.io/badge/libvirt-supported-blue)
![Buildx](https://img.shields.io/badge/buildx-arm64%20ready-green)


# docker-builder-vm

terraform project that make virtual machine to build docker images 


# installing deps
```bash
sudo pacman -S qemu libvirt virt-manager dnsmasq terraform vagrant terraform-provider-libvirt
```

# Start

```bash
terraform init
terraform plan
terraform apply
```

Next, retrieve ip address:

```bash
virsh domifaddr docker-builder
```

And go on:

```ba
ssh ubuntu@<ip>
```

Build a crossplatform image:

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t youruser/yourimage:latest . --load .
```

