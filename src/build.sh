#!/bin/bash -e

mkdir -p ../sysroot/usr/local/lib

gcc -shared -fPIC -o ../sysroot/usr/local/lib/libprocesshider.so processhider.c
