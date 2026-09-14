FROM debian:bookworm

RUN apt-get update -y \
    && apt install nginx -y \
    && apt install openssl -y

RUN rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init.sh"]