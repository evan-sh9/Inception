FROM debian:bookworm

RUN apt-get update -y \
    && apt-get -y install wget \
    wget\
    php\
    php-fpm\
    php-mysql\
    mariadb-client\
    && rm -rf /var/lib/apt/lists/*

RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www

