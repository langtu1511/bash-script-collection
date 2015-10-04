#!/bin/bash
#
# chkconfig: 2345 98 02
# description: joss service
# processname: josso
#
# Start/stop the queuing daemons.
#
### BEGIN INIT INFO
# Provides:          josso / $PROC_NAME
# Required-Start:    $syslog $time
# Required-Stop:     $syslog $time
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Regular background program processing daemon
### END INIT INFO


PROC_NAME=josso
PROC_HOME=/soft/josso

TIMELIMIT=60
SLEEPTIME=1
# Function to wait until the processes are killed
waitForJavaToDie()
{
	PROCESSES=`ps auxwww | grep 'java' | grep $PROC_HOME | grep -v 'grep'`
	while [ ! -z "$PROCESSES" ] && [ $SECONDS -lt $TIMELIMIT ] && [ $TIMELIMIT -ne 0 ]; do
		echo -n "."
		sleep $SLEEPTIME
		PROCESSES=`ps auxwww | grep 'java' | grep $PROC_HOME | grep -v 'grep'`
	done
	echo ""
	if [ ! -z "$PROCESSES" ]; then
		PROCESS_ID=`echo $PROCESSES | awk '{ print $2 }'`
		echo "Killing process: $PROCESS_ID"
		kill -9 $PROCESS_ID
	fi
}

case $1 in
	start)
		cd $PROC_HOME
		su - ${PROC_USER} -c "./bin/start"
		;;
	stop)
		cd $PROC_HOME
		su - ${PROC_USER} -c "./bin/stop"
		waitForJavaToDie
		;;
	restart)
		/etc/init.d/$PROC_NAME stop
		/etc/init.d/$PROC_NAME start
		;;
esac

# here