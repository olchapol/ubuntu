FOR ubuntu

MAINTAINER Paweł Olchowik <olchapol@wp.pl>

RUN set -x \
        && apk update \
        && apk add yaml python mysql-client php