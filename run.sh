#!/bin/sh
echo `qemu-system-x86_64 -L . -m 32 -fda ./Disk.img -M pc`