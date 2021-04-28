#!/bin/bash
#
# This file was automatically generated by s2e-env at 2021-04-22 11:19:01.050416
#
# This script is used to run the S2E analysis. Additional QEMU command line
# arguments can be passed to this script at run time.
#

uEmu_DIR="/root/s2e-arm"
BUILD_DIR="$uEmu_DIR/build"
BUILD=release
INSTALL_DIR="$BUILD_DIR/libs2e-$BUILD/arm-s2e-softmmu"
FIRMWARE="P2IM.CNC.elf"

# Comment this out to enable QEMU GUI
GRAPHICS=-nographic

if [ "x$1" = "xdebug" ]; then
  DEBUG=1
  shift
elif [ $1 ]; then
  echo "wrong parameter!"
  exit 8
fi


export S2E_CONFIG=uEmu-config.lua
export S2E_SHARED_DIR=$INSTALL_DIR
export S2E_MAX_PROCESSES=1
export S2E_UNBUFFERED_STREAM=1

#-z   是检查字符串是否为空
#检查文件为空用   -s来判断
#-a   file   True   if   file   exists.
#-d   file   True   if   file   exists   and   is   a   directory.
#-f   file   True   if   file   exists   and   is   a   regular   file.
#-n   string True   if   the   length   of   string   is   non-zero.

if [ $S2E_MAX_PROCESSES -gt 1 ]; then
    # Multi-threaded mode does not support graphics output, so we override
    # whatever settings were there before.
    export GRAPHICS=-nographic
fi

if [ "x$DEBUG" != "x" ]; then

    if [ ! -d "$BUILD_DIR/qemu-$BUILD" ]; then
        echo "No debug build found in $BUILD_DIR/qemu-$BUILD. Please run \`\`uEmu build -g\`\`"
        exit 1
    fi

    QEMU="$BUILD_DIR/qemu-$BUILD/arm-softmmu/qemu-system-arm"
	QEMU_MEMORY="2M"
    LIBS2E="$BUILD_DIR/libs2e-$BUILD/arm-s2e-softmmu/libs2e.so"

    rm -f gdb.ini

    echo handle SIGUSR1 noprint >> gdb.ini
    echo handle SIGUSR2 noprint >> gdb.ini
    echo set disassembly-flavor intel >> gdb.ini
    echo set print pretty on >> gdb.ini
    echo set environment S2E_CONFIG=$S2E_CONFIG >> gdb.ini
    echo set environment S2E_SHARED_DIR=$S2E_SHARED_DIR >> gdb.ini
    echo set environment LD_PRELOAD=$LIBS2E >> gdb.ini
    echo set environment S2E_UNBUFFERED_STREAM=1 >> gdb.ini
	echo set environment S2E_MAX_PROCESSES=1 >> gdb.ini
    # echo set environment LIBCPU_LOG_LEVEL=in_asm,int,exec >> gdb.ini
    # echo set environment LIBCPU_LOG_FILE=/tmp/log.txt >> gdb.ini
    # echo set environment S2E_QMP_SERVER=127.0.0.1:3322 >> gdb.ini
    echo set python print-stack full >> gdb.ini

    GDB="gdb --init-command=gdb.ini --args"


    $GDB $QEMU \
        -k en-us $GRAPHICS -M mps2-ans2e -cpu cortex-m3 -m $QEMU_MEMORY -enable-kvm \
        -serial file:s2e-last/serial.txt $QEMU_EXTRA_FLAGS \
        -kernel $FIRMWARE

else

    QEMU="$BUILD_DIR/opt/bin/qemu-system-arm"
	QEMU_MEMORY="2M"
    LIBS2E="$BUILD_DIR/opt/share/libs2e/libs2e-arm-s2e.so"

    LD_PRELOAD=$LIBS2E $QEMU \
        -k en-us $GRAPHICS -M mps2-ans2e -cpu cortex-m3 -m $QEMU_MEMORY -enable-kvm \
        -serial file:s2e-last/serial.txt $QEMU_EXTRA_FLAGS \
        -kernel $FIRMWARE

fi