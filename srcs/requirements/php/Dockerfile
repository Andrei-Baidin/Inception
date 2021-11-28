# syntax:docker/dockerfile:1

FROM alpine

ARG PHP_HOST
ARG MYSQL_HOST
ARG REDIS_HOST
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD

RUN apk update && apk add --no-cache php7-fpm php7-mcrypt php7-soap \
	php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip \
	php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd \
	php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader \
	php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype \
	php7-pecl-redis

WORKDIR /etc/php7/php-fpm.d

RUN sed -i.orig -e "s/listen = 127.0.0.1:9000/listen = ${PHP_HOST}:9000/g" www.conf \
	&& rm www.conf.orig

WORKDIR /var/www/

RUN wget https://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz \
	&& rm latest.tar.gz

RUN mv wordpress/wp-config-sample.php wordpress/wp-config.php \
	&& sed -i.orig -e "s/database_name_here/${DB_NAME}/g; \
	s/username_here/${DB_USER}/g; s/password_here/${DB_PASSWORD}/g; \
	s/localhost/${MYSQL_HOST}/g; \
	s/false );/false );\ndefine('WP_REDIS_HOST', '${REDIS_HOST}');/g" \
	wordpress/wp-config.php \
	&& rm wordpress/wp-config.php.orig

RUN wget https://downloads.wordpress.org/plugin/redis-cache.2.0.21.zip \
	&& unzip redis-cache.2.0.21.zip \
	&& rm redis-cache.2.0.21.zip \
	&& mkdir wordpress/wp-content/mu-plugins \
	&& cp redis-cache/includes/object-cache.php  wordpress/wp-content \
	&& mv redis-cache/ wordpress/wp-content/mu-plugins

COPY ./conf/load.php wordpress/wp-content/mu-plugins

WORKDIR /

ENTRYPOINT ["php-fpm7", "-F"]
