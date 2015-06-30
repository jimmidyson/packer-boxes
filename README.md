This repo provides base boxes mainly for [Vagrant](https://vagrantup.com)
built via [Packer](https://packer.io).

You will first need to download & unpack Packer from https://www.packer.io/downloads.html.
Ensure that the packer binary is in your `PATH`.

Image build configurations are stored in the `packer` directory. Switch to this directory &
run packer to build the appropriate image, e.g.

    packer build -parallel=false centos-7.1-x86_64.json

The `-parallel=false` flag is important as the configs build both VirtualBox & libvirt images -
these cannot run concurrently, hence disabling parallel builds.

If you just want to build the libvirt base image you can run:

    packer build --only=qemu centos-7.1-x86_64.json

Build output will be in the `builds` directory. These will be Vagrant boxes ready to import via:

    vagrant box add ../builds/libvirt/centos-7.1.box --name centos-7.1 -f

You can then use the `Vagrantfile` in the root dir to bring up the Vagrant box:

    vagrant up [--provider=libvirt]
