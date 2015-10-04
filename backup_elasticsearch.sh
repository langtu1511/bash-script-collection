#!/bin/bash

echo "
##################################
# BACKUP ELASTICSEARCH PROGRAM
# COMPANY: inspheris.fr
# EDITOR: duy.vu@inspheris.fr
# CONTACT: cto@inspheris.fr
##################################
"
echo "NOTE: The backup directory should be outside of user HOME directory. Because elasticsearch user may not have permission to access to home directory"

ES_USER='elasticsearch'         #ELASTICSEARCH user
ES_GROUP='elasticsearch'        #ELASTICSEARCH group
ES_INDICES="content"  			#Example: "index1, index2, index3"

BACKUP_LOCATION='/BACKUP'
SNAPSHOT_NAME=$(date "+%Y%m%d") # SNAPSHOT_NAME is based on the time (YYYYMMDD)
BACKUP_DIR=${BACKUP_LOCATION}/$(date "+ES_%Y%m%d_%Mh%S")  #The place where ES backup data will be saved. The name is base on date and time
LOG_FILE=${BACKUP_LOCATION}/${HOSTNAME}_ES_backup_${SNAPSHOT_NAME}.log
	
function main() {
	echo "INFO: Script is run with user: ${USER}"
	echo "INFO: Log file is: ${LOG_FILE}"
	echo "INFO: Backup directory: ${BACKUP_DIR}"

	echo "INFO: create ${BACKUP_DIR}"
	mkdir $BACKUP_DIR

	if [ $? -ne 0 ]; then
		echo "ERROR: Cannot create backup directory. Exit..."
		exit 1
	fi

	echo "INFO: Change ownership to Elasticsearch user"
	sudo chown -R ${ES_USER}:${ES_GROUP} $BACKUP_DIR

	if [ $? -ne 0 ]; then
		echo "ERROR: Cannot change ownership. Exit..."
		exit 1
	fi

	echo "INFO: Create repository backup in Elasticsearch"
	result=$(curl -s -XPUT "http://localhost:9200/_snapshot/backup" -d "{\"type\":\"fs\",\"settings\":{\"location\":\"${BACKUP_DIR}/\"}}")

	echo $result

	if [[ "${result}" == *"failed"* ||  "${result}" == *"Failed"*  ]] ; then
		echo "ERROR: Cannot create repository backup in Elasticsearch."
		echo "INFO: Deleting directory $BACKUP_DIR"
		rm -rf ${BACKUP_DIR}
		echo "INFO: Exit..."
		exit 1
	fi

	echo -e "\nINFO: Get current all repositories information"
	curl -s -XGET "http://localhost:9200/_snapshot/_all"

	echo -e "\nINFO: Get current repository information"
	curl -s -XGET "http://localhost:9200/_snapshot/backup"

	echo -e "\nINFO: Backup elasticsearch"
	curl -s -XPUT "http://localhost:9200/_snapshot/backup/${SNAPSHOT_NAME}?wait_for_completion=true" -d  "{\"indices\":\"${ES_INDICES}\", \"ignore_unavailable\":\"true\", \"include_global_state\":false}"

	echo -e "\nINFO: Delete repository"
	curl -s -XDELETE "http://localhost:9200/_snapshot/backup"


	
	echo -e "\nINFO: compress backup directory"
	cd $BACKUP_LOCATION
	tar -zcf ${BACKUP_DIR}.tgz ${BACKUP_DIR}/*
	
	echo -e "\nINFO: The backup files are"
	du -hs ${BACKUP_DIR}*
	
	echo "INFO: DONE"
}

main 2>&1 | tee -a ${LOG_FILE}
