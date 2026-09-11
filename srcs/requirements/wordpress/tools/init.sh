#!/bin/bash
set -e

DB_NAME="${MYSQL_DATABASE:-wordpress}"
DB_USER="${SQL_USER:-wp_user}"
DB_PASS="$(cat /run/secrets/db_password)"
DB_HOST="mariadb"

WP_ADMIN_USER="${WP_ADMIN_USER:-supervisor}"
WP_ADMIN_PASS="$(cat /run/secrets/wp_admin_password)"
WP_ADMIN_EMAIL="${WP_ADMIN_EMAIL:-admin@example.com}"

WP_USER="${WP_USER:-idk1}"
WP_USER_PASS="$(cat /run/secrets/wp_password)"
WP_USER_EMAIL="${WP_USER_EMAIL:-idk@example.com}"

WP_URL="${WEB_DOMAIN:-localhost}"
WP_TITLE="${WP_TITLE:-Inception}"

WP_PATH="/var/www/wordpress"

# en attente de mariaDB
until mariadb -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" \
    -e "SELECT 1;" &>/dev/null
do
    sleep 2
done

if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    wp config create --allow-root --path="${WP_PATH}" --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" --dbpass="${DB_PASS}" --dbhost="${DB_HOST}:3306"

    wp core install --allow-root --path="${WP_PATH}" --url="${WP_URL}" --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" --admin_password="${WP_ADMIN_PASS}" --admin_email="${WP_ADMIN_EMAIL}"

    wp user create --allow-root --path="${WP_PATH}" "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASS}" --role=author
    chown -R www-data:www-data "${WP_PATH}"
fi

exec php-fpm8.2 -F