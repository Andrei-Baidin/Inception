# syntax:docker/dockerfile:1

FROM alpine

ARG PHP_HOST

RUN apk update && apk add --no-cache redis

RUN sed -i.orig -e "s/bind 127.0.0.1 -::1/bind ${PHP_HOST}/g" /etc/redis.conf \
	&& rm /etc/redis.conf.orig

ENTRYPOINT ["redis-server", "--protected-mode", "no"]
