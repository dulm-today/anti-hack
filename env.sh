#!/bin/bash

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
SYSROOT=$THIS_DIR/sysroot
PREFIX=

export PATH=$SYSROOT/sbin:$SYSROOT/bin:$SYSROOT/usr/sbin:$SYSROOT/usr/bin:$PATH

export LD_PRELOAD=
export LD_LIBRARY_PATH="$SYSROOT/lib:$SYSROOT/usr/lib"
