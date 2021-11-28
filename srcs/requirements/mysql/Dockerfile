# syntax:docker/dockerfile:1

FROM alpine

ARG PHP_HOST
ARG ADMINER_HOST
ARG NET
ARG ROOT_PASSWORD
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD

COPY conf/wordpress.sql /

RUN apk update && apk add --no-cache mariadb mariadb-client openrc

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql \
	&& sed -i.orig -e 's/skip-networking/skip-networking=0/g' /etc/my.cnf.d/mariadb-server.cnf \
	&& rm /etc/my.cnf.d/mariadb-server.cnf.orig

#(mysqld_safe &) && sleep 1 \
RUN openrc && touch /var/run/openrc/softlevel \
	&& rc-service mariadb start \
	&& mysql -uroot -p{ROOT_PASSWORD} -e "DROP DATABASE IF EXISTS test;" \
	&& mysql -uroot -p${ROOT_PASSWORD} -e "CREATE DATABASE ${DB_NAME};" \
	&& mysql -uroot -p${ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${PHP_HOST}.${NET}' IDENTIFIED BY '${DB_PASSWORD}';" \
	&& mysql -uroot -p${ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${ADMINER_HOST}.${NET}' IDENTIFIED BY '${DB_PASSWORD}';" \
	&& mysql -uroot -p${ROOT_PASSWORD} -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';" \
	&& mysql -uroot -p${ROOT_PASSWORD} -e "FLUSH PRIVILEGES;" \
	&& mysql -uroot -p${ROOT_PASSWORD} ${DB_NAME} < /wordpress.sql \
	&& mysqladmin -uroot -p${ROOT_PASSWORD} shutdown

RUN	rm /wordpress.sql

ENTRYPOINT ["/usr/bin/mariadbd", "--basedir=/usr", "--datadir=/var/lib/mysql", \
			"--plugin-dir=/usr/lib/mariadb/plugin", "--user=mysql", \
			"--log-error=/var/lib/mysql/mysql.err", "--pid-file=mysql.pid"]
