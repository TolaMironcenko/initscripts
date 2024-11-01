#!/bin/sh

#--- import colors ---
. /usr/lib/init/colors.sh
#---------------------

#------------ rc function to poweron or poweroff ------------
rc() {
    if [ -d /etc/rc.d ] && [ $0 == "/etc/init.d/rcK" ]; then
        for service in $(ls -r /etc/rc.d); do
            /etc/rc.d/$service stop
        done
        return 1
    fi
    for service in /etc/rc.d/??*; do
        [ ! -f "$service" ] && continue
        case "$service" in
            *.sh)
                (
                    trap - INT QUIT TSTP
                    set start
                    . $service
                )
                ;;
            *)
                $service start
                ;;
        esac
    done
    sleep 1
    return 1
}
#------------------------------------------------------------

#--- restart function ---
restart() {
    $0 stop
    sleep 1
    $0 start
}

reload() {
    restart
}
#------------------------

#--- help function ---
help() {
    echo "$0 init script usage: $0 {start|stop|restart|reload|help}"
    exit 1
}
#---------------------

#------------ check status function ------------
check() {
    if [ $1 -ne 0 ]; then
        printf "$BBLUE**$BRED ERROR: $2\n$RESET"
        return
    fi
    printf "$BBLUE**$BGREEN SUCCESS: $2\n$RESET"
}
#-----------------------------------------------

#--- notify func ---
notify() {
    printf "$BBLUE**$BYELLOW $1\n$RESET"
}
#-------------------
