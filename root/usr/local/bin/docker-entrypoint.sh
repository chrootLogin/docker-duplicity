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

/usr/local/bin/duplicity-backup.sh -c /etc/duplicity-backup.conf $@
exit $?
