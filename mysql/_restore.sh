#!/bin/bash 
# Parámetros de Restore: s3, swift, dropbox
TMP_PATH=/tmp/


BACKUP_DIR=tmp/


MYSQL_PATH=/usr/bin/



function restore {

	echo "Downloading last backup..."
		BACKUP_FILENAME='backup.tar.gz'

		if [ $1 = "dropbox" ]; then
			BACKUP_COMPRESS="$(dropbox-uploader list ${DBOX_PATH} | tail -1 | awk '{print $3}')"
			dropbox-uploader download ${DBOX_PATH}${BACKUP_COMPRESS} ${TMP_PATH}${BACKUP_FILENAME}
		fi

		if [ $1 = "s3" ]; then
			BACKUP_COMPRESS="$(s3cmd ls s3://${BUCKET}/${BUCKET_PATH} | tail -1 | awk '{print $4}')"
			s3cmd get ${BACKUP_COMPRESS} ${TMP_PATH}${BACKUP_FILENAME}
		fi

		if [ $1 = "swift" ]; then
			BACKUP_COMPRESS="$(swift list ${BUCKET} -p ${BUCKET_PATH} | tail -1 )"
			swift download ${BUCKET} ${BACKUP_COMPRESS} -o ${TMP_PATH}${BACKUP_FILENAME}
		fi
		
	echo "...downloaded"


	echo -e "\nStarting decompressing..."

		tar xfz ${TMP_PATH}${BACKUP_FILENAME} -C ${TMP_PATH}

	echo "...decompressed"


	echo -e "\nRestoring Backup..."

		DB_PARAMETER="set foreign_key_checks = 0;"

		for DB in "${DATABASE[@]}"
		do :
			DB_PARAMETER+=" drop database ${DB};"
		done

		${MYSQL_PATH}mysql --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} --execute="${DB_PARAMETER}"

		${MYSQL_PATH}mysql --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} < ${TMP_PATH}${BACKUP_DIR}${BACKUP_NAME}
	
	echo "...restored"


	echo -e "\nRemoving temporal files..."

		rm -rf ${TMP_PATH}${BACKUP_COMPRESS}
		rm -rf ${TMP_PATH}${BACKUP_DIR}
	
	echo "...removed"


	echo -e "\n\nit's DONE!"

}