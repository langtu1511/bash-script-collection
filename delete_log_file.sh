#!/bin/bash


WORKING_DIR="/soft"
LOG_FILE=${WORKING_DIR}/clean_files_$(date "+%Y%m").log

DELETE_PERIOD="7"
COMPRESS_PERIOD="180"

LOG_DIRS=(
/soft/josso/data/log
/soft/tomcat7/logs
)

main () {
	echo "[+] INFO: Starting program at $(date)"
	for DIR in "${LOG_DIRS[@]}"; do
		echo "[+] INFO: Processing Directory $DIR"
		echo "[+] INFO: Directory ${DIR} - Before delete log file "
		ls -lh ${DIR}
		find ${DIR} -maxdepth 1 -type f  -mtime +${DELETE_PERIOD} | xargs -I {} rm {}
		echo "[+] INFO: Directory ${DIR} - Compress log files"
        find ${DIR} -maxdepth 1 -type f  -maxdepth 0 -mmin +${COMPRESS_PERIOD} | xargs -I {} gzip {}
		echo "[+] INFO: Directory ${DIR} - After delete and compress log files"
		ls -lh ${DIR}
	done
	echo "[+] INFO: DONE at $(date)"
}

main 2>&1 | tee -a ${LOG_FILE}
