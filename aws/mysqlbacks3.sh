#!/bin/bash

# MySQL backup to AWS S3 
# Desarrollado por Albatross - www.albatross.pe

MYSQL_USER=root
MYSQL_PASS=password
MYSQL_HOST=localhost

FILENAME="fullbackup"
DATABASE="--all-databases"

EXCLUDED_TABLES=(db.foo db.boo db2.foo db2.boo)

S3_BUCKET=bucketname
S3_PATH=mysql_backup/

MYSQLDUMP_PATH=/usr/bin/
TMP_PATH=/tmp/

DATE_STAMP=$(date +"-%Y-%m-%d-%H-%M")

IGNORED_TABLES=''
for TABLE in "${EXCLUDED_TABLES[@]}"
do :
   IGNORED_TABLES+=" --ignore-table=${TABLE}"
done


echo "Starting backup..."
${MYSQLDUMP_PATH}mysqldump --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} --no-data ${DATABASE} > ${TMP_PATH}${FILENAME}.sql
${MYSQLDUMP_PATH}mysqldump --user=${MYSQL_USER} --password=${MYSQL_PASS} --host=${MYSQL_HOST} --no-create-info ${IGNORED_TABLES} ${DATABASE} >> ${TMP_PATH}${FILENAME}.sql
echo "...done."

echo "Starting compression..."
tar czf ${TMP_PATH}${FILENAME}${DATE_STAMP}.tar.gz ${TMP_PATH}${FILENAME}.sql
echo "...done."

echo "Uploading to S3 the new backup..."
s3cmd put -f ${TMP_PATH}${FILENAME}${DATE_STAMP}.tar.gz s3://${S3_BUCKET}/${S3_PATH}
echo "...uploaded."

echo "Removing the temporal files..."
rm ${TMP_PATH}${FILENAME}.sql
rm ${TMP_PATH}${FILENAME}${DATE_STAMP}.tar.gz
echo "..."

echo "THE END"
