#!/usr/bin/env bash
#
# setup_overlay_l2.sh
# Copyright (C) 2019 jason <jason@kumpf.io>
#
# Distributed under terms of the MIT license.
#

# https://www.flockport.com/guides/advanced-container-networking
sudo ip link add vxlan0 type vxlan id 42 group 239.1.1.1 dev enp0s31f6
sudo brctl addbr vx0
sudo brctl addif vx0 vxlan0
