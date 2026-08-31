# Structure du Projet :

Posé une infrastructure web complète a l'interieur d'une VM.

### Dépendance du projet :

- NGINX
- WorldPress
- MariaDB

## Cahier des charges :

- **OS** : Une image penultimate entre debian et alpine
- **Stockage persistant** : Les données du site et de la base de données doivent survivre à la suppression  
    des conteneurs .  
    Elles sont stockées dans deux named volumes du chemin suivant : /home/login/data/
- **Gestion des processus** : Chaque service doit tourner en premier plan dans son conteneur respectif.
- **Sécurité & Variables** : Aucune donnée confidentiellene doit figurer dans les Dockerfile ou le dépôt Git.  
    Tout passe par un fichier .env et des Docker secrets.  
    Le compte admin WordPress ne peut pas s'appeler admin ou administrator.

# Règle

## Docker :

#### Global

- Les conteneurs docker ne pourront utilisé qu'uniquement TLSv1.2 ou TLSv1.3
- Les services WorldPress et MariaDB doivent possédé un stockage pérsistant, le Bind Mount est interdit
- Un docker-network doit établire une connection entre les conteneurs

#### World press

- Doit contenir uniquement le code source de WordPress et l'environnement d'exécution PHP-FPM.
- Un named volume pour WorldPress (Les fichiés du site)
- Ne doit pas posséder nginx

#### MariaDB

- Un named volume pour MariaDB (Base de données)
- Ne doit pas posséder nginx

# Donnée technique

## Arborescense du projet :

```sh
data/
├── Makefile
├── secrets/
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/
        │   │   └── nginx.conf
        │   └── tools/
        │
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/
        │   │   └── www.conf
        │   └── tools/
        │
        └── mariadb/
            ├── Dockerfile
            ├── .dockerignore
            ├── conf/
            │   └── 50-server.cnf
            └── tools/
```

# Mise en place

Le dossier rascine étant data.  
**Les deux premier répértoire a mettre en place :**

```
home/login/data/mariadb et /home/login/data/wordpress.
```

**Donnée les permissions au User :**

```sh
sudo apt install docker.io
sudo apt install docker-compose-plugin
sudo usermod -aG docker $USER
```

Cela permet une meilleurs sécurité pour donnée l'utilsation de docker a ceux qui en on besoin et pas donner la  
commande sudo a tout les utilsateurs qui aurait besoin de docker.

## MariaDB

Il s'agit du premier service que l'on va devoir mettre en place :

```sh
sudo apt install mariadb-server -y
```
Une fois installer se service ne va pas se lancé tout seul, il va falloir le lancer depuis un docker-compose en yml :
```yml
services:
  mariadb:
    build:
      context: ./requirements/mariadb
      dockerfile: Dockerfile
```
[Doc à propos docker compose](https://docs.docker.com/compose/intro/compose-application-model/)

Il va donc falloir crée le docker file de MariaDB pour **les dépendances**:

```docker
FROM debian:bookworm

RUN apt-get update -y && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

COPY conf/50-db.conf /etc/mysql/mariadb.conf.d/50-db.cnf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh
```
[Doc à propos des dockerfiles](https://docs.docker.com/build/concepts/dockerfile/)
### Config File
**Ensuite :**
```cnf
[mysqld]
datadir = /var/lib/mysql
socket = /run/mysqld/mysqld.sock
bind-address = 0.0.0.0
port = 3306
user = mysql
```
 ### Dockerfile MariaDB
```

```
### Se


## Lancé
```sh
docker compose up -d
```
**up** : Lecture
**-d** : Detaché du terminal

[Doc sécurité docker en lien au mot de passe](https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/secrets/)