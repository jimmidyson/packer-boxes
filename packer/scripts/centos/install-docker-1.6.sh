#!/bin/bash

yum install -y http://cbs.centos.org/kojifiles/packages/docker/1.6.2/4.gitc3ca5bb.el7/x86_64/docker-1.6.2-4.gitc3ca5bb.el7.x86_64.rpm
systemctl enable docker
groupadd docker
usermod -a -G docker vagrant

cat >> /etc/security/limits.conf <<EOF
*        hard    nproc           8192
*        soft    nproc           8192
*        hard    nofile          8192
*        soft    nofile          8192
EOF

sed -i "s|^OPTIONS=.*|OPTIONS='--selinux-enabled -H unix://var/run/docker.sock -H tcp://0.0.0.0:2375 --insecure-registry=172.0.0.0/8 --log-level=warn'|" /etc/sysconfig/docker

sed -i "s|^DOCKER_STORAGE_OPTIONS=.*$|DOCKER_STORAGE_OPTIONS='-s devicemapper --storage-opt dm.fs=xfs --storage-opt dm.thinpooldev=/dev/mapper/root-docker--pool'|" /etc/sysconfig/docker-storage
