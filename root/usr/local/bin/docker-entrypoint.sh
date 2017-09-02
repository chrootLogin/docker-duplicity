#!/bin/bash

if [[ -n "${AWS_ACCESS_KEY_ID}" && -n "${AWS_SECRET_ACCESS_KEY}" ]]
then
  cat <<EOF > /root/.s3cfg
$([ "$(echo "$DEST" | cut -d'/' -f1)" == "s3:" ] && echo "host_base = $(echo "$DEST" | cut -d'/' -f3)")
$([ "$(echo "$DEST" | cut -d'/' -f1)" == "s3:" ] && echo "host_bucket = $(echo "$DEST" | cut -d'/' -f3)")
bucket_location = us-east-1
use_https = True
access_key = ${AWS_ACCESS_KEY_ID}
secret_key = ${AWS_SECRET_ACCESS_KEY}
signature_v2 = False
EOF
fi

echo "Using following S3 conf:"
cat /root/.s3cfg

if [ "${DB_BACKUP}" == "true" ]; then
  if [ -z "${DB_TYPE}" ]; then
    echo "You need to set DB_TYPE..."
    exit 255
  fi

  if [ -z "${DB_USER}" ]; then
    echo "You need to set DB_USER..."
    exit 255
  fi

  if [ -z "${DB_PASSWORD}" ]; then
    echo "You need to set DB_PASSWORD..."
    exit 255
  fi

  echo "Creating database backup..."

  if [ "${DB_TYPE}" == "MARIADB" ]; then
    /usr/local/bin/mariadb-backup.sh
  else
    echo "Unsupported database: ${DB_TYPE}"
    exit 1
  fi
fi

/usr/local/bin/duplicity-backup.sh -c /etc/duplicity-backup.conf $@
exit $?
