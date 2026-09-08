#!/bin/bash
set -e

WEB_DOMAIN="${WEB_DOMAIN:-tiger-fish}" # catfish is cool but tiger-fish way more

if [ ! -f /etc/nginx/ssl/inception.crt ]; then
	openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout \
	/etc/nginx/ssl/inception.key -subj \
	"/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${WEB_DOMAIN}/UID=login"
fi

exec nginx -g "daemon off;"