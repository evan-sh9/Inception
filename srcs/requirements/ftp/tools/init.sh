#!/bin/sh
set -e

FTP_USER="${FTP_USER:-default}"
FTP_PASSWORD="$(cat /run/secrets/ftp_password)"

if [ -n "$FTP_USER" ] && [ -n "$FTP_PASSWORD" ]; then
    if ! id "$FTP_USER" >/dev/null 2>&1; then
        useradd -m -d /var/www/wordpress -s /bin/bash "$FTP_USER"
        echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    fi
fi

mkdir -p /var/run/vsftpd/empty /var/www/wordpress
exec vsftpd /etc/vsftpd.conf