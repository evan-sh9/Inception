FROM debian:bookworm

RUN apt-get update -y \
    && apt-get -y install wget \
    wget\
    php\
    php-fpm\
    php-mysql\
    mariadb-client\
    && rm -rf /var/lib/apt/lists/*

COPY conf/wordpress.conf /etc/php/8.2/fpm/pool.d/wordpress.conf
COPY tools/init.sh /usr/local/bin/init.sh

RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www \
    && chown -R www-data:www-data /var/www/wordpress \
    && rm -f /tmp/wordpress.tar.gz

RUN chmod +x /usr/local/bin/init.sh