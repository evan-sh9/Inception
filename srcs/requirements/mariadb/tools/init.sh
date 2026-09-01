#!/bin/bash
set -e

SQL_DATABASE="${MYSQL_DATABASE:-wordpress}"
SQL_USER="${MYSQL_USER:-wp_user}"

SQL_ROOT_PASS="$(cat /run/secrets/db_root_password)"
SQL_PASS="$(cat /run/secrets/db_password)"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "==> Initializing MariaDB datadir"

    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql

    echo "==> Starting MariaDB temporarily"

    mariadbd \
        --user=mysql \
        --datadir=/var/lib/mysql \
        --socket=/run/mysqld/mysqld.sock \
        --pid-file=/run/mysqld/mysqld.pid \
        --skip-networking &

    PID=$!

    echo "==> Waiting for MariaDB"

    until mariadb-admin \
        --socket=/run/mysqld/mysqld.sock \
        ping --silent
    do
        sleep 1
    done

    echo "==> Creating database/user"

    mariadb \
        --socket=/run/mysqld/mysqld.sock \
        -u root <<EOF

CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${SQL_USER}'@'%'
    IDENTIFIED BY '${SQL_PASS}';

GRANT ALL PRIVILEGES
    ON \`${SQL_DATABASE}\`.*
    TO '${SQL_USER}'@'%';

ALTER USER 'root'@'localhost'
    IDENTIFIED BY '${SQL_ROOT_PASS}';

FLUSH PRIVILEGES;

EOF

    echo "==> Stopping temporary MariaDB"

    mariadb-admin \
        --socket=/run/mysqld/mysqld.sock \
        -u root \
        -p"${SQL_ROOT_PASS}" \
        shutdown

    wait "$PID"

fi

echo "==> Starting MariaDB normally"

exec mariadbd \
    --user=mysql \
    --datadir=/var/lib/mysql