FROM python:2.7-alpine

ARG DUPLICITY_URL=https://code.launchpad.net/duplicity/0.7-series/0.7.12/+download/duplicity-0.7.12.tar.gz
ARG DUPLICITY_CSUM=29519f89f3e80d580c2b91a14be75cd9

ADD requirements.txt /tmp/requirements.txt

RUN apk -U --no-cache add \
  alpine-sdk \
  ca-certificates \
  gnupg \
  libffi \
  libffi-dev \
  librsync \
  librsync-dev \
  openssl \
  openssl-dev \
  tar \
  wget \
  && wget -O /tmp/duplicity.tgz ${DUPLICITY_URL} \
  && if [ "$DUPLICITY_CSUM" != "$(md5sum /tmp/duplicity.tgz | awk '{print($1)}')" ]; then echo "Wrong md5sum of downloaded file!"; exit 1; fi \
  && mkdir -p /tmp/duplicity \
  && tar -xvzf /tmp/duplicity.tgz --strip-components=1 -C /tmp/duplicity \
  && pip install -r /tmp/requirements.txt \
  && cd /tmp/duplicity \
  && python setup.py install \
  && apk --no-cache del \
  alpine-sdk \
  libffi-dev \
  librsync-dev \
  openssl-dev \
  wget \
  && rm -rf /tmp/* /var/cache/apk/*

ENTRYPOINT ["/usr/local/bin/duplicity"]
