FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

COPY conf/50-db.cnf /etc/mysql/mariadb.conf.d/50-db.cnf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh
