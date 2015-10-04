#!/bin/bash

###################################################
# [+] Setting array variables
# [bob in ~] ARRAY=(one two three)
# [bob in ~] echo ${ARRAY[*]}
# one two three
# [bob in ~] echo $ARRAY[*]
# one[*]
# [bob in ~] echo ${ARRAY[2]}
# three
# [bob in ~] ARRAY[3]=four
# [bob in ~] echo ${ARRAY[*]}
# one two three four

# [+] DELETE array variables
# [bob in ~] unset ARRAY[1]
# [bob in ~] echo ${ARRAY[*]}
# one three four
# [bob in ~] unset ARRAY
# [bob in ~] echo ${ARRAY[*]}
###########################

#!/bin/bash

if [ $(whoami) != 'root' ]; then
        echo "Must be root to run $0"
        exit 1;
fi
if [ -z $1 ]; then
        echo "Usage: $0 </path/to/httpd.conf>"
        exit 1
fi

httpd_conf_new=$1
httpd_conf_path="/usr/local/apache/conf"
login=htuser

farm_hosts=(web03 web04 web05 web06 web07)

for i in ${farm_hosts[@]}; do
        su $login -c "scp $httpd_conf_new ${i}:${httpd_conf_path}"
        su $login -c "ssh $i sudo /usr/local/apache/bin/apachectl graceful"

done
exit 0

#############################################################################################


#!/bin/bash
# This is get-tester-address.sh 
#
# First, we test whether bash supports arrays.
# (Support for arrays was only added recently.)
#
whotest[0]='test' || (echo 'Failure: arrays not supported in this version of
bash.' && exit 2)
                                                                                
#
# Our list of candidates. (Feel free to add or
# remove candidates.)
#
wholist=(
     'Bob Smith <bob@example.com>'
     'Jane L. Williams <jane@example.com>'
     'Eric S. Raymond <esr@example.com>'
     'Larry Wall <wall@example.com>'
     'Linus Torvalds <linus@example.com>'
   )
#
# Count the number of possible testers.
# (Loop until we find an empty string.)
#
count=0
while [ "x${wholist[count]}" != "x" ]
do
   count=$(( $count + 1 ))
done
                                                                                
#
# Now we calculate whose turn it is.
#
week=`date '+%W'`    	# The week of the year (0..53).
week=${week#0}       	# Remove possible leading zero.
                                                                                
let "index = $week % $count"   # week modulo count = the lucky person

email=${wholist[index]}     # Get the lucky person's e-mail address.
                                                                                
echo $email     	# Output the person's e-mail address.


#############################################################################################


email=`get-tester-address.sh`   # Find who to e-mail.
hostname=`hostname`    		# This machine's name.
                                                                                
#
# Send e-mail to the right person.
#
mail $email -s '[Demo Testing]' <<EOF
The lucky tester this week is: $email
                                                                                
Reminder: the list of demos is here:
    http://web.example.com:8080/DemoSites
                                                                                
(This e-mail was generated by $0 on ${hostname}.)
EOF












