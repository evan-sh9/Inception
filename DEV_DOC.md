# Developer Documentation

This document explains how a developer can set up, build, launch, and manage the **Inception** project: environment setup, Makefile/Docker Compose usage, container and volume management, and data persistence.

This documentation is intended for **developers**. If you only want to use the running stack (access the website, admin panel, credentials, health checks), please refer to `USER_DOC.md` instead.

---

## 1. Setting up the environment from scratch

### Prerequisites

- Docker Engine and Docker Compose (v2, `docker compose`)
- `make`
- A domain resolving to `127.0.0.1` on your machine (see below)

### Repository layout

```
.
├── Makefile
├── srcs/
│   ├── docker-compose.yml
│   ├── .env                # example values only, no real passwords
│   ├── requirements/
│   │   ├── nginx/
│   │   ├── wordpress/
│   │   ├── mariadb/
│   │   ├── redis/
│   │   ├── ftp/
│   │   ├── adminer/
│   │   ├── static/
│   │   └── portainer/
│   └── secrets/             # git-ignored, created locally
└── USER_DOC.md / DEV_DOC.md
```

### Configuration files

- **`srcs/.env`**
  Contains **non-sensitive** configuration only: domain name, database name, database user, WordPress username, WordPress site title, second (non-admin) user, etc. The `.env` committed in this repo is kept **as an example**, it does not contain any real password and must not be relied on for deployment as-is.

- **`srcs/secrets/`**
  This directory is **git-ignored** and must be created locally. It holds one file per sensitive value (passwords only), for example:
  ```
  srcs/secrets/
  ├── db_password.txt
  ├── db_root_password.txt
  ├── wp_admin_password.txt
  ├── wp_user_password.txt
  ├── ftp_password.txt
  └── ...
  ```
  These files are mounted into the containers as Docker secrets and referenced by the services at runtime.
  **No password ever lives in `.env` or in the codebase.**
**You need all of this file with a password for launching the project**

### Steps to set up from scratch

1. Clone the repository.
2. Create the `srcs/secrets/` directory and add the required password files (the file list above).
3. Adjust `srcs/.env` the .env (the env variable list below).
4. Map the domains to `127.0.0.1` in `/etc/hosts`:
```sh
   127.0.0.1 eprieur.42.fr
   127.0.0.1 static.eprieur.42.fr
   127.0.0.1 adminer.eprieur.42.fr
   127.0.0.1 portainer.eprieur.42.fr
```
exemple command :
```sh
sudo vim `/etc/hosts`
```

### Environment / secrets variable list

| File / Variable                | Used by      | Content                                   |
|---------------------------------|--------------|--------------------------------------------|
| `.env` → `DOMAIN_NAME`          | nginx        | Base domain (e.g. `eprieur.42.fr`)         |
| `.env` → `MYSQL_DATABASE`       | mariadb, wp  | Database name                              |
| `.env` → `MYSQL_USER`           | mariadb, wp  | Database user (non-root)                   |
| `.env` → `WORDPRESS_ADMIN_USER` | wordpress    | Admin username                             |
| `.env` → `WORDPRESS_ADMIN_EMAIL`| wordpress    | Admin email                                |
| `.env` → `WORDPRESS_USER`       | wordpress    | Second (non-admin) user's username         |
| `secrets/db_root_password.txt`  | mariadb      | MariaDB root password                      |
| `secrets/db_password.txt`       | mariadb, wp  | Password for `MYSQL_USER`                  |
| `secrets/wp_admin_password.txt` | wordpress    | WordPress admin password                   |
| `secrets/wp_user_password.txt`  | wordpress    | Second WordPress user's password           |
| `secrets/ftp_password.txt`      | ftp          | FTP user password                          |

> Adjust names/paths above to exactly match what your `docker-compose.yml` and Dockerfiles reference.

---

## 2. Building and launching the project

### With the Makefile (recommended)

```bash
make            # build images
make down       # stop and remove containers (volumes/data kept)
make re         # down + rebuild + up
make clean      # down + remove images built by this project
make fclean     # clean + remove volumes (⚠ deletes persistent data)
```

### Without the Makefile

```bash
cd srcs/
docker compose up --build -d   # build and start
docker compose down            # stop and remove containers
docker compose down -v         # stop and also remove volumes (⚠ deletes data)
```

All `docker compose` commands must be run from the `srcs/` directory, since that's where `docker-compose.yml` and `.env` live.

---

## 3. Managing containers and volumes

### Containers

```bash
docker ps                       # list running containers
docker ps -a                    # list all containers, including stopped ones
docker logs <container_name>    # view logs (e.g. nginx, wordpress, mariadb, redis, ftp, adminer, static, portainer)
docker logs -f <container_name> # follow logs in real time
docker exec -it <container_name> sh   # open a shell inside a container
docker compose restart <service>      # restart a single service
```

Service names (as declared in `docker-compose.yml`) typically include: `nginx`, `wordpress`, `mariadb`, `redis`, `ftp`, `adminer`, `static`, `portainer`.

### Images

```bash
docker images                   # list built images
docker compose build            # rebuild images without starting containers
docker compose build --no-cache # force a full rebuild
```

### Volumes

```bash
docker volume ls                # list volumes
docker volume inspect <name>    # show a volume's details, including its mount point on the host
```

To fully reset the project (containers, images, and volumes):
```bash
make fclean
```
/ ! \ This deletes the WordPress files and the database content. Use it only when you actually want a clean slate.

### Networks

```bash
docker network ls
docker network inspect <network_name>
```
All services communicate over one or more dedicated Docker networks defined in `docker-compose.yml`; only NGINX is expected to be reachable from outside the stack.

---

## 4. Where project data is stored and how it persists

Persistent data is stored using **named Docker volumes**, bind-mounted to a fixed location on the host so that data survives `make down` / container restarts. Data is only lost if the volumes themselves are explicitly removed (`make fclean` or `docker compose down -v`).

| Volume            | Content                                   | Used by service(s) |
|--------------------|---------------------------------------------|----------------------|
| WordPress volume   | WordPress core files, themes, plugins, uploads | `wordpress`, `nginx`, `ftp` |
| MariaDB volume     | Database files                              | `mariadb`, `adminer` |
| Portainer volume   | Portainer configuration/state               | `portainer`         |

You can find the exact host path for each volume with:
```bash
docker volume inspect <volume_name>
```
(look at the `Mountpoint` field).

Because the WordPress volume is shared between the `wordpress`, `nginx`, and `ftp` containers, files uploaded via FTP are immediately visible to WordPress/NGINX, and vice versa.

---

## Problem ?
If something doesn't behave as expected, start by checking `docker ps` and `docker logs <container_name>`, verify that `srcs/.env` and `srcs/secrets/` are correctly filled in. Most issues come from a missing or misnamed secret file at first launch.