FROM ubuntu:16.04

MAINTAINER Paweł Olchowik <olchapol@wp.pl>

#docker run -d -p 8080:80 -v /home/nimmis/html:/var/www/html nimmis/apache-php7

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

#MYSQL
ARG PACKAGE_URL=https://repo.mysql.com/yum/mysql-5.7-community/docker/x86_64/mysql-community-server-minimal-5.7.19-1.el7.x86_64.rpm
ARG PACKAGE_URL_SHELL=https://repo.mysql.com/yum/mysql-tools-community/el/7/x86_64/mysql-shell-1.0.9-1.el7.x86_64.rpm

# Install dependencies
#RUN apk add --no-cache php7-session php7-mysqli php7-mbstring php7-xml php7-gd php7-zlib php7-bz2 php7-zip php7-openssl php7-curl php7-opcache php7-json php7-fpm supervisor

#RUN apt-get update && \
##@    sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
#    apt-get -y upgrade
##@    apt-get install -y build-essential && \
##@    apt-get install -y software-properties-common && \
##@    apt-get install -y byobu curl git htop man unzip vim wget && \
##@    rm -rf /var/lib/apt/lists/*

# PHP
RUN apt-get update && \
    apt-get install -y php libapache2-mod-php  && \
    php-fpm php-cli php-mysqlnd php-pgsql php-sqlite3 php-redis && \
    php-apcu php-intl php-imagick php-mcrypt php-json php-gd php-curl && \
    phpenmod mcrypt && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# MYSQL
RUN apt-get update \
  && apt-get install mysql-server \
  && mysql_secure_installation \
  && mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY docker-entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /healthcheck.sh
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK CMD /healthcheck.sh

EXPOSE 3306 33060

# Add files.
##@COPY root/.bashrc /root/.bashrc
##@COPY root/.gitconfig /root/.gitconfig
##@COPY root/.scripts /root/.scripts

# Set environment variables.
##@ENV HOME /root

# Define working directory.
##@WORKDIR /root

# Define default command.
##@CMD ["bash"]

# Copy configuration
# COPY etc /etc/


FROM oraclelinux:7-slim


# Install server
RUN rpmkeys --import http://repo.mysql.com/RPM-GPG-KEY-mysql \
  && yum install -y $PACKAGE_URL \
  && yum install -y libpwquality \
  && rm -rf /var/cache/yum/*
RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


CMD ["mysqld"]
