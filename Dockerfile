FROM debian:12.11 AS base

ARG PHP_VERSION=PHP-8.2.9
ENV PHP_VERSION=${PHP_VERSION}

RUN apt update -y && apt upgrade -y && apt install -y \
    build-essential autoconf libtool bison re2c pkg-config make libxml2-dev libsqlite3-dev \
    git

RUN mkdir -p /php/logs
RUN mkdir -p /php/server
RUN echo "<?php phpinfo(); ?>" >> /php/server/index.php

WORKDIR /php
RUN git clone https://github.com/php/php-src.git
WORKDIR /php/php-src

# PHP version does not exists on php-src.git
RUN git branch -r | grep -i "origin/php-" | cut -d '/' -f 2 | grep -iq ${PHP_VERSION} && exit 0 || echo "Git branch ${PHP_VERSION} was not found at remote."; exit 1

RUN git checkout ${PHP_VERSION}

RUN ./buildconf
RUN ./configure \
        --prefix=/php/php-debug \
        --enable-debug \
        --with-config-file-path=/php/php-debug/etc

RUN make -j${nproc} && make install

RUN mkdir -p /php/php-debug/etc
COPY ./includes/php.ini /php/php-debug/etc

FROM alpine:3

COPY --from=base /php /php

CMD [ "tail", "-f", "/dev/null" ]
