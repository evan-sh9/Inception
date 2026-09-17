# USER_DOC.md — User Documentation

This document explains,  how to use the **Inception** project: what it does, how to start and stop it, how to access the website and the administration panel.

This documentation is intended for **end users and administrators**. If you are a developer looking to set up, build, or you need more information, please refer to `DEV_DOC.md` instead.

* * *

## 1\. What services does this stack provide?

| Service      | Role                                                                 |
|--------------|-----------------------------------------------------------------------|
| **NGINX**    | Reverse proxy / web server. It is the only entry point and serves the website over HTTPS (TLS). |
| **WordPress**| The website itself, running as a PHP-FPM application. It powers both the public site and the admin panel. |
| **MariaDB**  | The database server. It stores all WordPress data. |

In addition, the **bonus part**, which adds the following services:

| Service            | Role                                                                                         |
|---------------------|------------------------------------------------------------------------------------------------|
| **Redis**           | In-memory cache used by WordPress (via a caching plugin) to speed up page generation and reduce database load. |
| **FTP Server**      | Provides FTP access to the WordPress volume, so files can be uploaded/downloaded without going through a container shell. |
| **Adminer**         | A Web-based database administration tool, used to inspect and manage the MariaDB database through a browser. |
| **Static website**  | A simple additional website, served independently, you can replace this by an another website. |
| Portainer | A web-based Docker management UI, used to visually monitor and manage the stack's containers, images, volumes, and networks through a browser. |

All containers communicate over a dedicated, isolated Docker network, and persistent data (website files and database content) is stored on the host machine.

* * *

## 2\. Starting and stopping the project

The project is managed through a `Makefile` located at the root of the repository. As a user, you generally only need these commands:

### Start the project

```bash
make
```
without makefile :
```bash
cd srcs/; docker compose up
```
This builds the Docker images (if needed) and starts all containers in the background.

### Stop the project

```bash
make down
```
without makefile :
```bash
cd srcs/; docker compose down
```
This stops and removes the running containers without deleting your persistent data (website files, database).

### Currently running
Need to be in the srcs directory.
```bash
docker ps
```

You should see three containers running, typically named something like `nginx`, `wordpress`, and `mariadb`.

> For a full list of available commands (rebuild, clean volumes, remove images, etc.), see `DEV_DOC.md`.

* * *

## 3\. Accessing the website and the administration panel

### The public website

Wordpress, open a web browser and go to:

```sh
https://eprieur.42.fr
```

Static website :
```sh
https://static.eprieur.42.fr
```

> **Note:** For the domain to resolve on your machine, it usually needs to be mapped to `127.0.0.1` in your `/etc/hosts` file, for example:
> 
> ```
> 127.0.0.1 eprieur.42.fr
> ```

### Administration panel

The adminer panel is reachable at:

```sh
https://adminer.eprieur.42.fr/
```

The portainer panel is reachable at:
```sh
https://portainer.eprieur.42.fr/
```

From there, after logging in, you can manage part of this server.

* * *

## 4\. Locating and managing credentials

For security reasons, credentials are **never hard-coded** in the source code or committed to the repository. They are managed through environment variables and, where applicable, Docker secrets.

- **Environment variables**: defined in a `.env` file at the root of the project . It typically contains:
    - The domain name
    - Database name, user, 
    - WordPress username,
    - WordPress site title, and a second (non-admin) user
**Secret**
- **This file is git-ignored and must be created locally! See `DEV_DOC.md` for how to set it up)**, the secret file contained all passwords

**As a user/administrator**, if you need to know or change a credential:

1.  Open the `.env` file at the project root.
2.  Locate the corresponding variable (e.g., `WORDPRESS_ADMIN_PASSWORD`), variable list in the ```DEV_DOC.md```.
3.  Update it if needed, then restart the stack (`make down; make`) for the change to take effect.

> **Important:** Never share the `.env` file or secrets publicly, and never commit them to Git. Here the .env you can find in this repo is an example

* * *

## 5\. Checking that the services are running correctly

Here are a few simple checks to confirm the stack is healthy:

1.  **Container status**
    
    ```bash
    docker ps
    ```
    
    All three containers (`nginx`, `wordpress`, `mariadb`) should show a status of `Up`.  
3.  **Container logs** If something doesn't work as expected, check the logs of a specific container:
    
    ```bash
    docker logs <container_name>
    ```
    
    For example, `docker logs mariadb` will show whether the database started correctly.
    
5.  **Persistent data** You can confirm that data persists by restarting the project.

If you encounter an issue that isn't covered here, or if you need to set up the project from scratch, please refer to `DEV_DOC.md`.