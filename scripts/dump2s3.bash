#!/bin/bash

set -e -u -o pipefail

BACKUP_OUT_DIR="$PV_MOUNT_PATH/backup-`date +%s`"
# mydumper -h $DB_HOST -P $DB_PORT -u $DB_USER -p $DB_PASS -o $BACKUP_OUT_DIR

mydumper -h mysql.default.svc.cluster.local -P 3306 -u root -p password -o $BACKUP_OUT_DIR

