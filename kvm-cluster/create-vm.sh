#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo Specify a virtual-machine name.
  exit 1
fi

sudo virt-install \
	--name $1 \
	--ram 2048 \
	--disk path=/var/lib/libvirt/images/$1.img,size=30 \
	--vcpus 2 \
	--os-type linux \
	--os-variant ubuntu18.04 \
	--network bridge:virbr0,model=virtio \
	--graphics none \
	--console pty,target_type=serial \
	--location 'http://gb.archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/' \
	--extra-args 'console=ttyS0,115200n8 serial'


