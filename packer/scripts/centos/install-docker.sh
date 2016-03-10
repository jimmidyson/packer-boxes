#!/bin/bash

cat > /etc/yum.repos.d/docker-main.repo <<EOF
[docker-main-repo]
name=Docker Main Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum install -y docker-engine-1.9.1 docker-engine-selinux-1.9.1

mkdir /etc/systemd/system/docker.service.d/
cat >> /etc/systemd/system/docker.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// -H tcp://0.0.0.0:2375 --selinux-enabled --insecure-registry=172.0.0.0/8 --log-level=warn
#ExecStart=/usr/bin/docker daemon -H fd:// --selinux-enabled --storage-driver=devicemapper --storage-opt dm.fs=xfs --storage-opt dm.datadev=/dev/fedora/docker-data --storage-opt dm.metadatadev=/dev/fedora/docker-meta --insecure-registry=172.0.0.0/8 --log-level=warn
EOF

systemctl daemon-reload
systemctl enable docker
groupadd docker
usermod -a -G docker vagrant

cat >> /etc/security/limits.conf <<EOF
*        hard    nproc           16384
*        soft    nproc           16384
*        hard    nofile          16384
*        soft    nofile          16384
EOF
