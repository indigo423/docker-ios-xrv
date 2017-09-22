#!/bin/sh

ovs-vsctl add-br ovs-br0
ovs-vsctl add-br ovs-br1

qemu-kvm -cpu kvm64 -m 3072 \
-hda /root/iosxrv-k9-demo-6.1.2.img \
-serial telnet::8001,server,nowait \
-net nic,model=virtio,macaddr=00:56:09:58:84:d4 \
-net tap,ifname=xr1mg0,script=/root/bin/ovs0-ifup,downscript=/root/bin/ovs0-ifdown \
-net nic,model=virtio,macaddr=00:56:30:73:8d:38 \
-net tap,ifname=xr1g0,script=/root/bin/ovs1-ifup,downscript=/root/bin/ovs1-ifdown
