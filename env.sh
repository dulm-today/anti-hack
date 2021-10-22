#!/bin/bash

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
SYSROOT=$THIS_DIR/sysroot

export PATH=$SYSROOT/sbin:$SYSROOT/bin:$SYSROOT/usr/sbin:$SYSROOT/usr/bin:$PATH

# ld.so.preload has been set, set LD_PRELOAD to override it
export LD_PRELOAD=
export LD_LIBRARY_PATH="$SYSROOT/lib:$SYSROOT/usr/lib"

WHITE=$(tput setaf 7)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)

chmod u+x $SYSROOT/usr/bin/*
chmod u+x $SYSROOT/usr/sbin/*
chmod u+x $SYSROOT/usr/local/lib/*
