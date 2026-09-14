FROM debian:bookworm

RUN apt-get update -y \
    && apt-get -y install wget \
	curl \
    ca-certificates \
    php\
    php-fpm\
    php-mysql\
    php-redis\
    mariadb-client\
    msmtp-mta\
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && mkdir -p /var/www \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www \
    && chown -R www-data:www-data /var/www/wordpress \
    && rm -f /tmp/wordpress.tar.gz

RUN  mkdir -p /run/php

COPY conf/wordpress.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init.sh"]