# Inception

## Description

The **Inception** school project aims to broaden knowledge in system administration and DevOps through containerization. The objective is to set up a small-scale infrastructure composed of multiple services running in isolated containers, with persistent volume.

Each service is built using a dedicated `Dockerfile` based on standard Debian , without using pre-built application images from Docker Hub.

### Services Stack

| Service      | Role                                                                 |
|--------------|-----------------------------------------------------------------------|
| **NGINX**    | Reverse proxy / web server. It is the only entry point and serves the website over HTTPS (TLS). |
| **WordPress**| The website itself, running as a PHP-FPM application. It powers both the public site and the admin panel. |
| **MariaDB**  | The database server. It stores all WordPress data. |                                                                                    |
| **Redis**           | In-memory cache used by WordPress (via a caching plugin) to speed up page generation and reduce database load. |
| **FTP Server**      | Provides FTP access to the WordPress volume, so files can be uploaded/downloaded without going through a container shell. |
| **Adminer**         | A Web-based database administration tool, used to inspect and manage the MariaDB database through a browser. |
| **Static website**  | A simple additional website, served independently, you can replace this by an another website. |
| Portainer | A web-based Docker management UI, used to visually monitor and manage the stack's containers, images, volumes, and networks through a browser. |

## Technical Choices & Comparisons

### Docker Usage
Services run in isolated containers on a bridge network. Persistent data is stored in ~/data/, and custom entrypoint scripts load secrets and handle service setup on startup

### Technical Comparisons

#### Virtual Machines vs Docker
- **Virtual machine :**
The difference between the two lies mainly in their management, a VM virtualizes a new kernel so that we can create our virtual machine. Running a VM for every application we want to launch quickly becomes resource-intensive.

- **Docker :**
This is precisely why Docker was created, we create containers that rely directly on our host Linux kernel rather than virtualizing additional kernels, making it significantly faster and much less resource-intensive.

![docker schema](:/08d86d0ab577436ab637d384075b67b9)

#### Secrets vs Environment Variables
* **Environment Variables**: Environment variables defined in a `.env` file at the root of the project . It typically contains, The domain name , Database name, user, WordPress username, WordPress site title.
* **Docker Secrets**: Injected securely as temporary, in-memory files mounted inside `/run/secrets/` within specific containers. They prevent accidental exposure in configuration files or runtime logs.

#### Docker Network vs Host Network
* **Host Network**: Removes network isolation between the container and the host. The container shares the host's IP address and network stack directly, which can cause port conflicts and security vulnerabilities.
* **Docker Network (Bridge)**: Creates an isolated virtual network segment. Containers communicate with each other using internal IP addresses and DNS resolution based on service names, exposing only required ports to the outside world.

#### Docker Volumes vs Bind Mounts
* **Bind Mounts**: Directly mount a file or folder from the host file system into a container. They depend heavily on the host's directory structure and permissions.
* **Docker Volumes**: Managed entirely by Docker within host storage. They offer improved performance, cross-platform portability, better security isolation, and easier lifecycle management.

---

## Instructions

### Prerequisites
* Docker Engine (`>= 20.10`)
* Docker Compose (`>= 2.0`)
* `make` utility
* Linux as Os

### Setup / Launch

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/inception.git
   cd inception
   ```

2. **Configure environment variables and secrets:**
   * Create a `.env` file in `srcs/.env` containing your domain name, usernames, and volume paths (all information in the **DEV_DOC.md !**).
   * Place sensitive passwords inside `srcs/secrets/` (e.g., `db_password.txt`, `ftp_password.txt`) (and don't  push this file in your git ! ) .

3. **Build and start the infrastructure:**
   ```bash
   make
   ```
   *The data directories (`/home/volt/data/`) will be automatically creates , builds all custom Docker images, and starts the container stack in detached mode.*

### Makefile Commands

| Command | Action |
| :--- | :--- |
| `make` / `make all` | Builds and starts all containers. |
| `make stop` | Stops running containers without removing them. |
| `make down` | Stops and removes containers and networks. |
| `make clean` | Removes containers, networks, and untagged images. |
| `make fclean` | Performs a full cleanup, including volume data deletion (`/data`). |
| `make re` | Rebuilds the entire infrastructure from scratch. |

---

## Resources
### Documentation & References
* [Wordpress-Nginx guide](https://www.ionos.com/digitalguide/hosting/blogs/wordpress-nginx/)
* [Docker Compose Specification](https://docs.docker.com/compose/intro/compose-application-model/)
* [vsftpd variable explained](http://vsftpd.beasts.org/vsftpd_conf.html)
* [vsftpd example config](https://gist.github.com/yuikns/d4967713693bef2b6423c89ddd3d155d)
* [Portainer Guide](https://docs.portainer.io/start/install-ce/server/docker/linux)
* [Adminer Setup](https://dev.to/rafi021/set-up-postgresql-and-adminer-using-docker-for-local-web-development-104m)
  