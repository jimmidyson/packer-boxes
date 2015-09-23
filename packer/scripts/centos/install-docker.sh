#!/bin/bash

curl -sSL https://get.docker.com/ | sh

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
*        hard    nproc           8192
*        soft    nproc           8192
*        hard    nofile          8192
*        soft    nofile          8192
EOF
