FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*
COPY site/ /var/www/html/index.html
CMD ["nginx", "-g", "daemon off;"]