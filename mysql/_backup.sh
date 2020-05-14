#!/bin/bash 
# Parámetros de Backup: s3, swift, dropbox

TMP_PATH=/tmp/


MYSQLDUMP_PATH=/usr/bin/


DATE_STAMP=$(date +"-%Y-%m%d-%H%M")



function backup {

	echo "Starting backup..."

		DB_PARAMETER=""

		if [ $DATABASES = "--all-databases" ]; then
		    DB_PARAMETER=$DATABASES
		    
		else

		    DB_PARAMETER="--databases "
		    
		    for DB in "${DATABASES[@]}"
		    do :
		      DB_PARAMETER+="${DB} "
		    done
		fi

		IGNORED_TABLES=""

		for TABLE in "${EXCLUDED_TABLES[@]}"
			do :
			IGNORED_TABLES+=" --ignore-table=${TABLE}"

		done
	
		${MYSQLDUMP_PATH}mysqldump --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} --no-data ${DB_PARAMETER} > ${TMP_PATH}${BACKUP_NAME}.sql
		${MYSQLDUMP_PATH}mysqldump --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} --no-create-info ${IGNORED_TABLES} ${DB_PARAMETER} >> ${TMP_PATH}${BACKUP_NAME}.sql
	
	echo "...backuped"


	echo -e "\nStarting compression..."
	
		tar czf ${TMP_PATH}${BACKUP_NAME}${DATE_STAMP}.tar.gz ${TMP_PATH}${BACKUP_NAME}.sql
	
	echo "...compressed"


	echo -e "\nUploading new backup to ${1}... "
		
		if [ $1 = "dropbox" ]; then
			dropbox-uploader upload ${TMP_PATH}${BACKUP_NAME}${DATE_STAMP}.tar.gz ${DBOX_PATH} 
		fi

		if [ $1 = "s3" ]; then
			s3cmd put -f ${TMP_PATH}${BACKUP_NAME}${DATE_STAMP}.tar.gz s3://${BUCKET}/${BUCKET_PATH} 
		fi

		if [ $1 = "swift" ]; then
			swift upload ${BUCKET} ${TMP_PATH}${BACKUP_NAME}${DATE_STAMP}.tar.gz --object-name ${BUCKET_PATH}${BACKUP_NAME}${DATE_STAMP}.tar.gz
		fi

	echo "...uploaded"


	echo -e "\nRemoving temporal files..."

		rm ${TMP_PATH}${BACKUP_NAME}.sql
		rm ${TMP_PATH}${BACKUP_NAME}${DATE_STAMP}.tar.gz

	echo "...deleted"


	echo -e "\n\rTHE END"

}