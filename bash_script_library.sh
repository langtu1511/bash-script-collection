#!/bin/bash
# REF LINK: http://bash.cyberciti.biz/guide/Shell_functions_library
# You can store all your function in a function files called functions library.
# You can load all function into the current script or the command prompt.
# The syntax is as follows to load all functions:
# . /path/to/your/functions.sh


# set variables 
declare -r TRUE=0
declare -r FALSE=1
declare -r PASSWD_FILE=/etc/passwd
 
##################################################################
# Purpose: Converts a string to lower case
# Arguments:
#   $1 -> String to convert to lower case
##################################################################
function to_lower() 
{
    local str="$@"
    local output     
    output=$(tr '[A-Z]' '[a-z]'<<<"${str}")
    echo $output
}


##################################################################
# Purpose: Display an error message and die
# Arguments:
#   $1 -> Message
#   $2 -> Exit status (optional)
##################################################################
function die() 
{
    local m="$1"	# message
    local e=${2-1}	# default exit status 1
    echo "$m" 
    exit $e
}


##################################################################
# Purpose: Return true if script is executed by the root user
# Arguments: none
# Return: True or False
##################################################################
function is_root() 
{
   [ $(id -u) -eq 0 ] && return $TRUE || return $FALSE
}
 

##################################################################
# Purpose: Return true $user exits in /etc/passwd
# Arguments: $1 (username) -> Username to check in /etc/passwd
# Return: True or False
##################################################################
function is_user_exits() 
{
    local u="$1"
    grep -q "^${u}" $PASSWD_FILE && return $TRUE || return $FALSE
}

##################################################################
# Purpose: Wait process (service) to stop itself in a number of seconds.
# 			Then kill it if it is still running
# Arguments: None
# Return: None
##################################################################
function waitForProcessToDie()
{
	PROC_NAME=tomcat
	PROC_HOME=/soft/tomcat

	TIMELIMIT=60
	SLEEPTIME=1

	PROCESSES=`ps auxwww | grep 'java' | grep $PROC_NAME | grep $PROC_HOME | grep -v 'grep'`
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

##################################################################
# Purpose: Print the usage of the program
# Arguments: None
# Return: None
##################################################################

function usage() {
	echo "Usage: $0 Arguments"
}

#
# returns lowercase string
#
function tolower {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

#
# returns uppercase string
#
function toupper {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}


















#END
