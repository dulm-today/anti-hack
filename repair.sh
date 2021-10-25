#!/bin/bash

THIS_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
DATA_DIR=$THIS_DIR/log

. $THIS_DIR/env.sh

virus_files="/etc/rc.d/init.d/selinux
/etc/rc.d/init.d/DbSecuritySpt
/etc/profile.d/php.sh
/etc/profile.d/supervisor.sh
/etc/cron.d/zzh
/etc/cron.d/syszh
/etc/cron.d/phps
/etc/cron.d/phpx
/etc/long.conf
/etc/master
/etc/zzh
/etc/newinit.sh
/etc/sphp
/etc/spts
/etc/.supervisor/conf.d/123.conf
/etc/.supervisor/supervisord.conf
/etc/.bashpid
/etc/.pwd.lock
/etc/.qucfu.pid
/etc/.sftp
/etc/.supervisor
/etc/.updated
/root/.configrc
/root/.ssh/authorized_keys
/tmp/.X26-unix
/usr/bin/bsd-port
/usr/bin/zh
/usr/bin/dget
/usr/bin/iss
/usr/bin/nets
/usr/bin/ips
/usr/bin/shh
/usr/bin/cphp
/usr/bin/lockr
/usr/bin/.locks
/usr/bin/.bget
/usr/bin/dpkgd
/usr/bin/longbak
/usr/bin/lockrc
/usr/bin/.funzip
/usr/bin/-bash
/usr/bin/dbused
/usr/bin/sysmd
/usr/bin/.locksc
/usr/bin/.sshd
/usr/bin/.sh
/usr/sbin/-bash
/usr/sbin/systemd
/usr/sbin/https
/usr/sbin/httpss
/usr/lib/systemd/system/pwnriglhttps.service
/usr/local/bin/pnsca
/usr/local/bin/pnscan
/usr/lib/mysql/.sh
/usr/lib/mysql/mysql
"

virus_proc="/usr/bin/bsd-port/getty
/bin/\\.sh
\\./\\.sh
/usr/bin/\\.sshd
"

file_manual_check="/etc/hosts
/etc/profile
/etc/crontab
"

echo_info() {
    local opt=$1
    local name=$2
    shift 2
    printf "%-6s ${WHITE}%-32s${RESET} $@" "$opt" "$name"
}

echo_ok() {
    local result=$1
    shift
    printf "[${GREEN}%-6s${RESET}] %s\n" "$result" "$*"
}

echo_fail() {
    local result=$1
    shift
    printf "[${RED}%-6s${RESET}] %s\n" "$result" "$*"
}

echo_warn() {
    local result=$1
    shift
    printf "[${YELLOW}%-6s${RESET}] %s\n" "$result" "$*"
}

echo_result() {
    if [ $1 -eq 0 ]; then
        echo_ok "SUCCESS"
    else
        echo_fail "FAILED"
    fi
}

check_file() {
    echo_info "Check" "$1"
    if [ -e "$1" ]; then
        echo_fail "EXIST"
    else
        echo_ok "OK"
    fi
}

check_proc() {
    echo_info "Check" "$1"

    local pid=`pgrep -f "$1"`
    if [ -n "$pid" ]; then
        echo_fail "EXIST" "PID: $pid"
    else
        echo_ok "OK"
    fi
}


kill_proc() {
    local pid=`pgrep -f "$1"`

    echo_info "Kill" "$1"

    if [ -z "$pid" ]; then
        echo_warn "SKIP"
        return 0
    fi

    kill -9 $pid
    echo_ok "OK" "PID: $pid"
}


remove_file() {
    echo_info "Remove" "$1"

    if [ -e "$1" ]; then
        chattr -i -a -- "$(dirname $1)" && \
            chattr -i -a -- "$1" && \
            rm -rf -- "$1"
        echo_result $?
    elif [ -L "$1" ]; then
        rm -rf -- "$1"
        echo_result $?
    else
        echo_warn "SKIP"
    fi
}

remove_dir() {
    echo_info "Remove" "$1 ..." "\n"

    # delete file
    for item in `find $1`
    do
        if [ -f "$item" ]; then
            remove_file "$item"
        fi
    done

    # delete directory
    for item in `find $1`
    do
        remove_file "$item"
    done
}

remove_all() {
    while [ $# -ne 0 ]
    do
        if [ -d "$1" ]; then
            remove_dir "$1"
        else
            remove_file "$1"
        fi
        shift
    done
}

move_file() {
    echo_info "Moving" "$1"

    if [ -e "$1" -a -e "$2" ]; then
        chattr -i -a -- "$1" && \
            chattr -i -a -- "$2" && \
            mv "$1" "$2"
        echo_result $?
    else
        echo_warn "SKIP"
    fi
}

echo_file() {
    local file="$1"
    shift

    echo_info "Write" "$file"

    chattr -i -a -- "$file" && \
      echo "$*"> "$file"

    echo_result $?
}

chattr_file() {
    if [ -e "$1" ]; then
        local ret=`lsattr -a $1 2>/dev/null | grep -E '^----(i|-a)'`
        if [ -n "$ret" ]; then
            echo_info "Chattr" "$file"
            chattr -i -a -- "$1"
            echo_result $?
        fi
    fi
}

restore_file() {
    echo_info "Restore" "$1"

    if [ -e "$1" ]; then
        chattr -i -a -- "$1" && \
            cp -f "${SYSROOT}$1" "$1"
    else
        cp -f "${SYSROOT}$1" "$1"
    fi

    echo_result $?
}

check_health() {
    echo_info "Check" "Computer Status"

    local ld=`cat /etc/ld.so.preload`
    if [ "$ld" == "/usr/local/lib/libprocesshider.so" ]; then
        echo_fail "HACKED"
        return 1
    else
        echo_ok "HEALTH"
        return 0
    fi
}

dump_info() {
    mkdir -p $DATA_DIR

    echo "====================================================================="
    echo "Dumping informations:"
    echo "---------------------------------------------------------------------"
    echo "${BLUE}Exception files:${RESET}"
    if [ ! -f "$DATA_DIR/exception_files.txt" ]; then
        lsattr -a -R / 2>/dev/null | grep -E '^----(i|-a)' | tee $DATA_DIR/exception_files.txt
    else
        cat $DATA_DIR/exception_files.txt
    fi

    echo "---------------------------------------------------------------------"
    echo "${BLUE}Virus files:${RESET}"
    for virus in $virus_files
    do
        check_file $virus
    done

    echo "---------------------------------------------------------------------"
    echo "${BLUE}Virus process:${RESET}"
    for virus in $virus_proc
    do
        check_proc $virus
    done
}

kill_procs() {
    echo "====================================================================="
    echo "Kill processes:"
    for virus in $virus_proc
    do
        kill_proc $virus
    done
}


remove_files() {
    echo "====================================================================="
    echo "Deleting files:"

    # delete virus files
    remove_all $virus_files

    # DbSecuritySpt && selinux
    for file in `find /etc/rc.d | grep -E '(DbSecuritySpt|selinux)'`
    do
        remove_file $file
    done

    # hosts
    remove_all /etc/hosts.allow /etc/hosts.deny
    move_file /etc/deny.bak /etc/hosts.deny
    move_file /etc/allow.bak /etc/hosts.allow
}

restore_files() {
    echo "====================================================================="
    echo "Restore files:"

    # truncate ld.so.preload
    echo_file "/etc/ld.so.preload" ""

    # edit /etc/crontab
    echo_info "Edit" "/etc/crontab"
    chattr -i -a -- "/etc/crontab" && \
        sed -i 's#.*/etc/sphp.*##g' /etc/crontab
    echo_result $?

    # restore libprocesshider.so
    #restore_file "/usr/local/lib/libprocesshider.so"

    # restore /usr/bin
    for file in `ls $SYSROOT/usr/bin`
    do
        restore_file "/usr/bin/$file"
    done

    # restore /usr/sbin
    for file in `ls $SYSROOT/usr/sbin`
    do
        restore_file "/usr/sbin/$file"
    done

    echo "${YELLOW}Please check these files manually: ${RESET}[[["
    # chattr exception files
    for file in `sed -E 's#.*\s(.*)#\1#g' $DATA_DIR/exception_files.txt`
    do
        chattr_file "$(echo $file | awk '{print $1}')"
    done

    for file in $file_manual_check
    do
        echo_info "Check" "${YELLOW}$file${RESET}" "\n"
    done
    echo "]]]"
}

# check
check_health

# dump info
dump_info

# kill process
kill_procs

# remove files
remove_files

# restore files
restore_files
