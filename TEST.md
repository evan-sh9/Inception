# Global Basic Test

## TLS Certificat Test :

```sh
curl -vI -k https://eprieur.42.fr 2>&1 | grep -E "SSL connection|TLS"
```

## MariaDB Test

Root connection test :

```sh
docker exec -it mariadb_container mariadb -u root -p
```

User connection test :

```sh
docker exec -it wordpress_container mariadb -h mariadb -u volt -p Inception_DB
```

Verify mariDB user :

```sh
docker exec -it mariadb_container mariadb -u root -p -e "SELECT User, Host FROM mysql.user;"
```

Container test :

Data base :

```sh
SHOW DATABASES;
```

## WordPress Test

Verify php-fpm presence :

```sh
docker exec -it wordpress_container ps aux | grep php-fpm
```

Verify Wordpress user

```sh
docker exec -it wordpress_container wp user list --allow-root --path=/var/www/wordpress
```

Create a post :

```sh
docker exec -it wordpress_container wp post create --post_title="IDK" --post_status=publish --allow-root --path=/var/www/wordpress
# you can restart : docker compose stop && docker compose up
# for try the volume persistence
```

## Web Test

The website is working ?

```sh
curl -kI https://catfish.42.fr
```

Change the website URL :

```sh
echo -e '127.0.0.1\tcatfish.42.fr' | sudo tee -a /etc/hosts
# + change the WEB_DOMAIN in the .env
```

## Redis
View event :
```sh
docker exec -it redis_container redis-cli monitor
```

## FTP
Try to connect :
```sh
ftp 127.0.0.1
```
You can test to deplace file with filezila.

## Portainer

```
https://portainer.eprieur.42.fr/
```

## Adminer
```
https://adminer.eprieur.42.fr/
```