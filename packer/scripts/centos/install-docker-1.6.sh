#!/bin/bash

yum install -y cloud-utils-growpart http://cbs.centos.org/kojifiles/packages/docker/1.6.2/4.gitc3ca5bb.el7/x86_64/docker-1.6.2-4.gitc3ca5bb.el7.x86_64.rpm http://cbs.centos.org/kojifiles/packages/docker-storage-setup/0.5/3.el7.centos/noarch/docker-storage-setup-0.5-3.el7.centos.noarch.rpm
systemctl enable docker
groupadd docker
usermod -a -G docker vagrant
systemctl start docker-storage-setup

cat >> /etc/security/limits.conf <<EOF
*        hard    nproc           8192
*        soft    nproc           8192
*        hard    nofile          8192
*        soft    nofile          8192
EOF

sed -i "s|^OPTIONS=.*|OPTIONS='--selinux-enabled -H unix://var/run/docker.sock -H tcp://0.0.0.0:2375 --insecure-registry=172.0.0.0/8 --log-level=warn'|" /etc/sysconfig/docker
