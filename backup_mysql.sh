#!/bin/bash

echo "
##################################
# MySQL BACKUP  PROGRAM
# COMPANY: inspheris.fr
# EDITOR: duy.vu@inspheris.fr
# CONTACT: cto@inspheris.fr
##################################
"


USER="root"
DB_NAME="siec"
BACKUP_LOCATION=/backup/mysql
BACKUP_FILE=$BACKUP_LOCATION/SIEC_`date +%Y%m%d_%Hh%M`.sql

echo -n "Enter MySQL password of user $USER:"
read PASSWORD

mysqldump --user=$USER --password=$PASSWORD --databases $DB_NAME > $BACKUP_FILE

echo "The backup file is $BACKUP_FILE"
ls -ld $BACKUP_FILE


