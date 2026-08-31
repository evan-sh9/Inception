#!/bin/bash
set -e

SQL_DATABASE="${MYSQL_DATABASE:-wordpress}"
SQL_USER="${MYSQL_USER:-wp_user}"
SQL_ROOT_PASS="$(cat /run/secrets/db_root_password)"
SQL_PASS="$(cat /run/secrets/db_password)"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

mariadb-install-db \
    --user=mysql \
    --datadir=/var/lib/mysql \
    > /dev/null

mariadbd --user=mysql --bootstrap <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASS}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
EOF
fi

exec mariadbd --user=mysql --console