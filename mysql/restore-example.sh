#!/bin/bash

# Restore MySQL
# Desarrollado por Albatross
# www.albatross.pe

MYSQL_USER=root
MYSQL_PASS=mysql
MYSQL_HOST=localhost



DATABASES=(db1 db2)

# Incluir nombre con .sql
BACKUP_NAME="backup.sql"


# Compatible con Amazon S3 & Openstack Swift
BUCKET=bucket
BUCKET_PATH=client/database/


# Exclusivo para Dropbox
DBOX_PATH=/dir/on/dropbox



# Ejecución de restore
source "$(pwd)/_restore.sh"
restore swift
