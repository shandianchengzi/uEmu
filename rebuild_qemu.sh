#!/bin/bash

pushd .
cd $uEmuDIR/qemu
./configure --prefix=$uEmuDIR/build/opt --target-list=arm-softmmu --disable-smartcard --disable-virtfs --disable-xen --disable-bluez --disable-vde --disable-libiscsi --disable-docs --disable-spice --disable-strip --enable-debug
make
sudo rm -rf ../build/qemu-release/*
sudo cp -a * ../build/qemu-release/
popd