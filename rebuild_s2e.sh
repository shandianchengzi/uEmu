#!/bin/bash

pushd .
cd $uEmuDIR/build
# sudo make -f $uEmuDIR/scripts/Makefile install || exit -1
# sudo make -C $uEmuDIR/build/libs2e-release/arm-s2e-softmmu clean
sudo make -C $uEmuDIR/build/libs2e-release/arm-s2e-softmmu
sudo make -C $uEmuDIR/build/libs2e-release/arm-s2e-softmmu install
echo "[+] rebuild s2e success!"
popd
