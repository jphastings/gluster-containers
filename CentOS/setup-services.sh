#!/bin/bash

# verbose and exit on error
set -ex

# Copy files to required locations
cp gluster-fake-disk.service /etc/systemd/system/gluster-fake-disk.service
mkdir -p /usr/libexec/gluster
cp fake-disk.sh /usr/libexec/gluster/fake-disk.sh
cp gluster-setup.service /etc/systemd/system/gluster-setup.service
cp gluster-setup.sh /usr/sbin/gluster-setup.sh
cp gluster-block-setup.service /etc/systemd/system/gluster-block-setup.service
cp gluster-block-setup.sh /usr/sbin/gluster-block-setup.sh
cp update-params.sh /usr/local/bin/update-params.sh
cp status-probe.sh /usr/local/bin/status-probe.sh
cp tcmu-runner-params /etc/sysconfig/tcmu-runner-params
cp gluster-check-diskspace.service  /etc/systemd/system/gluster-check-diskspace.service
cp check_diskspace.sh /usr/local/bin/check_diskspace.sh
cp exec-on-host.sh /usr/sbin/exec-on-host


# Set required bits
chmod 644 /etc/systemd/system/gluster-setup.service
chmod 644 /etc/systemd/system/gluster-check-diskspace.service
chmod 755 /usr/libexec/gluster/fake-disk.sh
chmod 500 /usr/sbin/gluster-setup.sh
chmod 644 /etc/systemd/system/gluster-block-setup.service
chmod 500 /usr/sbin/gluster-block-setup.sh
chmod +x /usr/local/bin/update-params.sh
chmod +x /usr/local/bin/status-probe.sh
chmod +x /usr/local/bin/check_diskspace.sh

# Bootstrap services
systemctl disable nfs-server.service
systemctl enable gluster-fake-disk.service
systemctl enable gluster-setup.service
systemctl enable gluster-block-setup.service
systemctl enable gluster-blockd.service
systemctl enable glusterd.service
systemctl enable gluster-check-diskspace.service
