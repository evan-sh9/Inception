FROM debian:bookworm

RUN apt-get update -y \
    && apt-get install -y php \
    php-mysqli \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html \
    && curl -L -o /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v6.0.2/adminer-6.0.2.php

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]