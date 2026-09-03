FROM debian:bookworm

RUN apt-get update -y \
    && apt-get update -y \
    && apt install nginx -y \
    && apt install OpenSSL -y \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN chmod +x /usr/local/bin/init.sh