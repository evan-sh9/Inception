#!/bin/bash
set -e

sed -i 's/bind 127.0.0.1 -::1/bind 0.0.0.0/' /etc/redis/redis.conf
sed -i 's/protected-mode yes/protected-mode no/' /etc/redis/redis.conf

if ! grep -q "maxmemory 256mb" /etc/redis/redis.conf; then
    echo "maxmemory 256mb" >> /etc/redis/redis.conf
    echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf
fi

exec redis-server /etc/redis/redis.conf --daemonize no