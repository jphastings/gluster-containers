FROM fedora:36

ENV NAME="gluster-fedora" \
    DESC="GlusterFS on Fedora" \
    VERSION=0 \
    RELEASE=1 \
    ARCH=x86_64 \
    REPO="$FGC" \
    container=docker

LABEL name="$REPO/$NAME" \
      version="$VERSION" \
      release="$RELEASE.$DISTTAG" \
      architecture="$ARCH" \
      vendor="Red Hat, Inc" \
      summary="$DESC" \
      usage="docker run -d -P --tmpfs /run --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup $REPO/$NAME" \
      io.k8s.display-name="$DESC" \
      io.k8s.description="GlusterFS is a distributed and scalable network filesystem. Using common, off-the-shelf hardware you can create large, distributed storage solutions for media streaming, data analysis, and other data- and bandwidth-intensive tasks." \
      io.openshift.tags="gluster,glusterfs,gluster-fedora" \
      com.redhat.component="$NAME" \
      maintainer="Jose A. Rivera <jarrpa@redhat.com>, Humble Chirammal <hchiramm@redhat.com>"

VOLUME [ "/sys/fs/cgroup/" ]

ADD https://github.com/gluster/gluster-containers/blob/master/README.md /README.md

COPY gluster-setup.sh gluster-brickmultiplex.service gluster-brickmultiplex.sh gluster-setup.service /
COPY gluster-fake-disk.service /etc/systemd/system/gluster-fake-disk.service
COPY fake-disk.sh /usr/libexec/gluster/fake-disk.sh

RUN dnf --nodocs -y update && \
    sed -i "s/LANG/\#LANG/g" /etc/locale.conf && \
    dnf --nodocs -y install systemd-udev && \
    dnf --nodocs -y install glusterfs-server && \
    dnf --nodocs -y install python3-dbus && \
    dnf --nodocs -y install nfs-utils && \
    dnf --nodocs -y install attr && \
    dnf --nodocs -y install iputils && \
    dnf --nodocs -y install iproute && \
    dnf --nodocs -y install glusterfs-geo-replication && \
    dnf --nodocs -y install openssh-server && \
    dnf --nodocs -y install openssh-clients && \
    dnf --nodocs -y install cronie && \
    dnf --nodocs -y install tar && \
    dnf --nodocs -y install rsync && \
    dnf --nodocs -y install sos && \
    dnf --nodocs -y install xfsprogs && \
    dnf clean all && \
    (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* &&\
    rm -f /etc/systemd/system/*.wants/* &&\
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* &&\
    rm -f /lib/systemd/system/anaconda.target.wants/* &&\
    sed -i '/Port 22/c\Port 2222' /etc/ssh/sshd_config && \
    sed -i 's/Requires\=rpcbind\.service//g' /usr/lib/systemd/system/glusterd.service && \
    sed -i 's/rpcbind\.service/gluster-setup\.service/g' /usr/lib/systemd/system/glusterd.service && \
    sed -i.save -e "s#udev_sync = 1#udev_sync = 0#" -e "s#udev_rules = 1#udev_rules = 0#" -e "s#use_lvmetad = 1#use_lvmetad = 0#" -e "s#obtain_device_list_from_udev = 1#obtain_device_list_from_udev = 0#" /etc/lvm/lvm.conf && \
    # Back up the default/base configuration. The target directories get
    # overwritten with the directories from the host which are initially
    # empty.
    mkdir -p /etc/glusterfs_bkp /var/lib/glusterd_bkp /var/log/glusterfs_bkp && \
    cp -r /etc/glusterfs/* /etc/glusterfs_bkp && \
    cp -r /var/lib/glusterd/* /var/lib/glusterd_bkp && \
    cp -r /var/log/glusterfs/* /var/log/glusterfs_bkp && \
    mv /gluster-setup.sh /usr/sbin/gluster-setup.sh && \
    mv /gluster-brickmultiplex.service /etc/systemd/system/gluster-brickmultiplex.service && \
    mv /gluster-brickmultiplex.sh /usr/sbin/gluster-brickmultiplex.sh && \
    mv /gluster-setup.service /etc/systemd/system/gluster-setup.service && \
    chmod 755 /usr/libexec/gluster/fake-disk.sh && \
    chmod 644 /etc/systemd/system/gluster-setup.service && \
    chmod 500 /usr/sbin/gluster-setup.sh && \
    ln -s /usr/sbin/gluster-setup.sh /usr/sbin/setup.sh && \
    chmod 644 /etc/systemd/system/gluster-brickmultiplex.service && \
    chmod 500 /usr/sbin/gluster-brickmultiplex.sh && \
    systemctl disable systemd-udev-trigger.service && \
    systemctl disable systemd-udevd.service && \
    systemctl disable nfs-server.service && \
    systemctl enable rpcbind.service && \
    systemctl enable sshd.service && \
    systemctl enable gluster-fake-disk.service && \
    systemctl enable gluster-setup.service && \
    systemctl enable gluster-brickmultiplex.service && \
    systemctl enable glusterd.service && \
    mkdir -p /var/log/core;

# mask services that aren't required in the container and/or might interfere
RUN true \
    && systemctl mask getty.target \
    && systemctl mask systemd-journal-flush.service \
    && systemctl mask rpcbind.socket \
    && true

EXPOSE 2222 111 245 443 24006 24007 2049 8080 6010 6011 6012 38465 38466 38468 38469 49152 49153 49154 49156 49157 49158 49159 49160 49161 49162

CMD ["/usr/sbin/init"]
