FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    curl \
    tar \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://github.com/portainer/portainer/releases/download/2.21.5/portainer-2.21.5-linux-amd64.tar.gz | tar -xz -C /opt/
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init.sh"]
