FROM centos/systemd

LABEL maintainer "Ronny Trommer <ronny@opennms.org>"

## Setup OpenVswitch, KVM, and SSH Envrionment
RUN yum install -y epel-release.noarch; \
    yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-pike/rdo-release-pike-1.noarch.rpm; \
    yum install -y qemu-img qemu-kvm openvswitch python-openvswitch python-pip supervisor openssh-server libvirt uml_utilities tunctl net-tools; \
    ln -s /usr/libexec/qemu-kvm /usr/bin/qemu-kvm
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"; \
    python get-pip.py; \
    pip install supervisor

## Add supervisord configuration file
COPY supervisord.conf /etc/supervisord.conf

## Add IOS-XRV Image and init scripts
COPY iosxrv-k9-demo-6.1.2.img /root/iosxrv-k9-demo-6.1.2.img
COPY bin /root/bin
RUN chmod +x /root/bin/*
COPY bootvm.sh /root/bootvm.sh
RUN chmod +x /root/bootvm.sh

RUN systemctl enable sshd; \
    systemctl enable openvswitch; \
    systemctl enable libvirtd; \
    systemctl enable supervisord

## Setup a default password for root - You should probably change this.
RUN echo "root:defaultpassword" | chpasswd

## Export SSH port
EXPOSE 22 8001

## Start supervisord
CMD ["/usr/sbin/init"]
