#!/bin/bash

# MySQL Backup
# Desarrollado por Albatross
# www.albatross.pe

MYSQL_USER=root
MYSQL_PASS=mysql
MYSQL_HOST=localhost



DATABASES=(db1 db2)

EXCLUDED_TABLES=(db1.foo db1.boo db2.foo db2.boo)


# Excluir la extensión al nombre
BACKUP_NAME="backup"


# Compatible con Amazon S3 & Openstack Swift
BUCKET=bucketname
BUCKET_PATH=mysql_backup/



# Exclusivo para Dropbox
DBOX_PATH=/mysql_backup/



# Ejecución de backup
source "$(pwd)/_backup.sh"
backup swift
