#!/bin/bash
set -e

SQL_DATABASE="${MYSQL_DATABASE:-wordpress}"
SQL_USER="${SQL_USER:-wp_user}"
SQL_ROOT_PASS="$(cat /run/secrets/db_root_password)"
SQL_PASS="$(cat /run/secrets/db_password)"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
    service mariadb start;

    until mariadb-admin ping --silent &>/dev/null; do
        sleep 1
    done

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASS}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASS}';"

    mysqladmin -u root -p"${SQL_ROOT_PASS}" shutdown
fi

exec mysqld_safe