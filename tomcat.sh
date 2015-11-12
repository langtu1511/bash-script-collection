#!/bin/bash
#
# chkconfig: 2345 98 02
# description:  tomcat service
# processname: tomcat
#
# Start/stop the tomcat daemons.


PROC_USER=ennet
PROC_NAME=tomcat
PROC_HOME=/soft/ennetv4/tomcat7

TIMELIMIT=60
SLEEPTIME=1

declare -r TRUE=0
declare -r FALSE=1

print_proccess() {
        ps -ef | grep 'java' | grep $PROC_HOME | grep -v 'grep'
}

get_process_pid(){
        ps -ef | grep 'java' | grep $PROC_HOME | grep -v 'grep' | awk '{ print $2 }'
}

is_running() {
        PROCESSES=$(get_process_pid)
        if [ ! -z "$PROCESSES" ]; then
                return $TRUE
        else
                return $FALSE
        fi
}

wait_and_kill()
{
        PROCESSES=$(get_process_pid)
        while [ ! -z "$PROCESSES" ] && [ $SECONDS -lt $TIMELIMIT ] && [ $TIMELIMIT -ne 0 ]; do
                echo -n "."
                sleep $SLEEPTIME
                PROCESSES=$(get_process_pid)
        done
        echo ""
        if [ ! -z "$PROCESSES" ]; then
                echo "Kill proccess $PROCESSES"
                kill -9 $PROCESSES
        fi
}

status_service(){
        if is_running
        then
                echo "Service $PROC_NAME is RUNNING"
                print_proccess
        else
                echo "Service $PROC_NAME is STOPPED"
        fi
}


start_service(){

        if is_running
        then
                echo "Service $PROC_NAME is running"
                print_proccess
        else
                rm -rf $PROC_HOME/work/* $PROC_HOME/temp/*
                cd $PROC_HOME/logs
                su $PROC_USER -c "../bin/startup.sh"
                if [ $? -ne 0 ]
                then
                        echo "There is ERROR while starting service ${PROC_NAME}. Exit..."
                        return 1
                else
                        sleep 5
                        echo "Service $PROC_NAME started"
                        status_service
        fi
        fi
}

stop_service(){
        cd $PROC_HOME/logs
        su $PROC_USER -c "../bin/shutdown.sh"
        wait_and_kill
        echo "Service $PROC_NAME has been stopped"
}

case $1 in
        start)
                start_service
                ;;

        stop)
                stop_service
                ;;

        restart)
                stop_service
                start_service
                ;;
        status)
                status_service
                ;;
esac
