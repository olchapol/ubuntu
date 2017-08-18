FROM ubuntu:16.04

MAINTAINER Paweł Olchowik <olchapol@wp.pl>

#docker run -d -p 8080:80 -v /home/nimmis/html:/var/www/html nimmis/apache-php7

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
# RUN apk add --no-cache php7-session php7-mysqli php7-mbstring php7-xml php7-gd php7-zlib php7-bz2 php7-zip php7-openssl php7-curl php7-opcache php7-json nginx php7-fpm supervisor

RUN \
    sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y build-essential && \
    apt-get install -y software-properties-common && \
    apt-get install -y byobu curl git htop man unzip vim wget && \
    rm -rf /var/lib/apt/lists/*

# PHP
RUN apt-get update && \
    apt-get install -y php libapache2-mod-php  \
    php-fpm php-cli php-mysqlnd php-pgsql php-sqlite3 php-redis \
    php-apcu php-intl php-imagick php-mcrypt php-json php-gd php-curl && \
    phpenmod mcrypt && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Add files.
ADD root/.bashrc /root/.bashrc
ADD root/.gitconfig /root/.gitconfig
ADD root/.scripts /root/.scripts

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]

# Copy configuration
# COPY etc /etc/