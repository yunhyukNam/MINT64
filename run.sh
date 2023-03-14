#!/bin/sh
echo `qemu-system-x86_64 -L . -fda ./Disk.img -M pc`