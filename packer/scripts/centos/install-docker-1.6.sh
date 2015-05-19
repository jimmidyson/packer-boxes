#!/bin/bash

cat >/etc/yum.repos.d/openshift-deps.repo <<EOF
[openshift-deps]
name=Openshift Dependencies - x86_64 software and updates
baseurl=https://mirror.openshift.com/pub/openshift-v3/dependencies/centos7/x86_64/
gpgcheck=0
enabled=1
EOF

yum install -y docker docker-logrotate && rm -rf /var/cache/yum
systemctl enable docker
groupadd docker
usermod -a -G docker vagrant

cat >> /etc/security/limits.conf <<EOF
*        hard    nproc           8192
*        soft    nproc           8192
*        hard    nofile          8192
*        soft    nofile          8192
EOF

sed -i "s|^OPTIONS=.*|OPTIONS='--selinux-enabled -H unix://var/run/docker.sock -H tcp://0.0.0.0:2375 --insecure-registry=172.0.0.0/8'|" /etc/sysconfig/docker
