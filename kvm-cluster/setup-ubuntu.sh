#!/usr/bin/env bash

if [[ -z $1 ]];then
  echo "No node name provided."
  echo "Usage: ./setup-ubuntu.sh k8s-master"
  exit 1
fi

NODE=$1

virsh list --all
virsh net-dhcp-leases default | grep $NODE | awk '{ print $5}'

# Replace with output from above without the /24
VHOST='192.168.122.207'

ssh ubuntu@$VHOST

sudo apt install net-tools

ssh-keygen -t rsa
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDh/i+o2c91Dcex2sc3JcLsw/sy5tRY463HIlwxMhdql/v/WFa9Ch8YZcGu7WBOVQhBHDVslJeml6rTLUglse6YatsEfY+F+cBy39KV8Q70sL4NoOsjzdXPEgVfSfST06qYQ+oEHNcs7Xb5gZrUhJOVk7LeGMR8Fyx9ZiZCgHWbzFxPZMb9bT17lpqinnVTIbXBCCP0yG/mB1uJTALqriQ26s7es+VnUxyMXisfAKxFyYFPK7z0Ma48oqqv80l9xaj4EqDPvnYIDiqyuuviUo9uw3mxU8A9SLOt/8C3krnmQI2O99koQEcA154edkOvuqcVDNZl8kr0m/UItG6Glq1n jason@kumpf.io >> ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub >> .ssh/authorized_keys

sudoedit /etc/sudoers
#
#ubuntu	ALL=(ALL) NOPASSWD:ALL

sudo vi /etc/netplan/01-netcfg.yaml
#
#network:
#  version: 2
#  renderer: networkd
#  ethernets:
#    enp1s0:
#      dhcp4: no
#      dhcp6: no
#      addresses: [192.168.122.10/24, ]
#      gateway4:  192.168.122.1
#      nameservers:
#        addresses: [192.168.122.1, 8.8.8.8]

sudo netplan apply

w=$(virt-sysprep --list-operations | egrep -v 'fs-uuids|lvm-uuids|ssh-userdir' | awk '{ printf "%s,", $1}' | sed 's/,$//') \
virt-sysprep -d $NODE --hostname $NODE --keep-user-accounts ubuntu --enable $w --firstboot-command 'dpkg-reconfigure openssh-server'

