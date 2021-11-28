# syntax:docker/dockerfile:1

FROM alpine

ARG ADMINER_HOST

RUN apk update && apk add --no-cache php7-fpm php7-mcrypt php7-soap \
	php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip \
	php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd \
	php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader \
	php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype \
	php7-session

RUN wget https://www.adminer.org/static/download/4.8.1/adminer-4.8.1-mysql-en.php
RUN mkdir -p /var/www
RUN mv adminer-4.8.1-mysql-en.php /var/www/adminer.php

RUN sed -i.orig -e "s/listen = 127.0.0.1:9000/listen = ${ADMINER_HOST}:9000/g" /etc/php7/php-fpm.d/www.conf \
	&& rm /etc/php7/php-fpm.d/www.conf.orig

ENTRYPOINT ["php-fpm7", "-F"]
