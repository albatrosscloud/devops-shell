#!/bin/bash

# Restore MySQL Database from DROPBOX
# Desarrollado por Albatross - www.albatross.pe


DBOX_PATH=/dir/on/dropbox

BACKUP_DIR=dir/on/backup/
BACKUP_NAME=backupfilename.sql
DATABASE=database


MYSQL_USER=root
MYSQL_PASS=mysql
MYSQL_HOST=localhost


TMP_PATH=/tmp/
MYSQL_PATH=/usr/bin/



echo "Downloading last backup..."
BACKUP_COMPRESS="$(dropbox-uploader list ${DBOX_PATH} | tail -1 | awk '{print $3}')"
dropbox-uploader download ${DBOX_PATH}${BACKUP_COMPRESS} ${TMP_PATH}${BACKUP_COMPRESS}
echo "...done."


echo "Starting decompressing..."
tar xfz ${TMP_PATH}${BACKUP_COMPRESS} -C ${TMP_PATH}
echo "...done."


echo "Restoring Backup..."
${MYSQL_PATH}mysql --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} --execute="drop database ${DATABASE};"
${MYSQL_PATH}mysql --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} --execute="create database ${DATABASE};"

${MYSQL_PATH}mysql --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} --database=${DATABASE} < ${TMP_PATH}${BACKUP_DIR}${BACKUP_NAME}
echo "...done"


echo "Removing temporal files..."
rm -rf ${TMP_PATH}${BACKUP_COMPRESS}
rm -rf ${TMP_PATH}${BACKUP_DIR}
echo "..."


echo "it's DONE!"

