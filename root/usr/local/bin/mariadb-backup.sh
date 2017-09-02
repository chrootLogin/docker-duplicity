#!/bin/bash
set -e
set -x

if [ ! -d /sql ]; then
  mkdir /sql
fi

mysqldump -h db -u "${DB_USER}" -p"${DB_PASSWORD}" --all-databases > /sql/all-databases.sql
