#!/bin/bash
set -e

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
	/etc/nginx/ssl/inception.key -subj \
	"/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=login.42.fr/UID=login"
fi

exec nginx -g "daemon off;"