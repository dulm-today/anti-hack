#!/bin/bash

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

. $THIS_DIR/env.sh


virus_files="/etc/rc.d/init.d/selinux
/etc/rc.d/init.d/DbSecuritySpt
/usr/bin/bsd-port
/usr/bin/zh
/usr/bin/dpkgd
/usr/sbin/ss
/usr/
"

remove_file() {

}

copy_file() {

}


usage() {
    cat <<EOF
usage: $0 <rm|cp>
EOF
}

case $1 in
    rm)
        shift
        remove_file "$@"
        ;;
    cp)
        shift
        copy_file "$@"
        ;;
    *)
        usage
        exit 1
        ;;
esac
