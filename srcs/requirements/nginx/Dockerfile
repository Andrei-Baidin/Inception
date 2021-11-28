# syntax:docker/dockerfile:1

FROM alpine

ARG DOMAIN
ARG PHP_HOST

COPY conf/wordpress.conf /

RUN apk update && apk add --no-cache nginx openssl

WORKDIR /etc/nginx/http.d

RUN rm default.conf \
	&& mv /wordpress.conf . \
	&& sed -i.orig -e "s/localhost/${DOMAIN}/g; s/127.0.0.1/${PHP_HOST}/g" wordpress.conf \
	&& rm wordpress.conf.orig

WORKDIR /etc/ssl

RUN openssl genrsa -out certkey.key 4096 \
	&& openssl req -x509 -new -key certkey.key -days 365 -out cert.crt \
	-subj "/C=US/ST=San Andreas/L=Los Santos/O=Grove Street	Families/OU=LS/CN=wordpress"

WORKDIR /

ENTRYPOINT ["nginx", "-g", "daemon off;"]
