set -euo pipefail

BACKUP_NAME="${BACKUP_NAME}"
BACKUP_OUT_DIR="${PV_MOUNT_PATH}/${BACKUP_NAME}"
DB_USER=`echo ${DB_USER} | base64 -d`
DB_PASS=`echo ${DB_PASS} | base64 -d`

echo "making full backup to ${BACKUP_OUT_DIR}"
mydumper -h ${DB_HOST} -P ${DB_PORT} -u ${DB_USER} -p ${DB_PASS} -o ${BACKUP_OUT_DIR} {{ .Values.mydumperArgs }}
echo "backup finished"

echo "configuring minio client.."
ACCESS_KEY=`echo ${ACCESS_KEY} | base64 -d`
SECRET_KEY=`echo ${SECRET_KEY} | base64 -d`
mc_alias={{ .Values.minio.alias }}
mc_url={{ .Values.minio.url }}
mc_api={{ .Values.minio.api }}
mc_path={{ .Values.minio.path }}
mc_bucket={{ .Values.minio.bucket }}
./mc alias set ${mc_alias} ${mc_url} ${ACCESS_KEY} ${SECRET_KEY} --api ${mc_api} --path 

set -x

echo "uploading ${BACKUP_NAME} to remote object storage"
tar -cf - ${BACKUP_OUT_DIR} | pigz | ./mc pipe ${mc_alias}/${mc_bucket}/${BACKUP_NAME}.tar.gz
