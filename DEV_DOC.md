This document is intended for someone who wants to understand the internal architecture or modify the code
# Set up the environment from scratch (prerequisites, configuration files, secrets).
## Virtual Machine
## Configuration file
## Secrets
Create a secrets folder in the makefile level and create the four passwords needed for mariadb and wordpress:  
`db_password.txt`  
`db_root_password.txt`  
`wp_admin_password.txt`  
`wp_user_password.txt`  
## Environment
Follow the `.env.example` is to create the `.env` needed for the proyect. Do no use admin in the WP user name.
# Build and launch the project.
Just use `make` in the folder respository after setting the previous section.
## How it works
### 1. Makefile
It is the file in the root of the project that automates everything. It does not contain container configuration, but commands to call Docker Compose.  
**Content**: Rules like all, build, down, up, clean, fclean, prune and re.  
**Function**: Execute docker-compose commands in a simplified way.  

### 2. Docker-compose.yml
It is thte file called by the makefile. It is located inside the srcs/ folder. Defines the "map" of how the services relate.  

**Services**: Defines a Mariadb, Wordpress, and Nginx.Each one indicates:
- Container name for the repository to avoid standard naming with prefixes and sufixes like `srcs-wordpress-1`.
- Base image from which the container will be built.
- Path of its own Dockerfile to be built locally, since pre-built images are not allowed.
- Volume path, is standard for each container, execpt nginx which doesn't have its own, but needs access to wordpress's.
- Network that will allow them to communicate between them.
- Environment file to manage databases names and users.
- Secrets that will be used in the container
- Port exposed only with nginx, the only aislated container allowed to be accessed externally throught the port 443, world standard for encrypted HTTPS traffic.
- Healthcheck to ensure the container state, this will allow to make dependencies to build in order.
- Dependency is used to make an ordered built, starting with mariadb and only when finished, working and healthy start with wordpress and then nginx.
- Restart policies to automatically restart in case of failure or system crash, `restart: always`.  

**Networks**: There is a internal network (e.g., `inception`) so that they can communicate with each other.  

**Named Volumes**: Registers mariadb_data and wordpress_data.  

**Secrets**: used to manage confidential information like passwords of databases, it has the secret's name and associates the path to the file with the content.  

**Configuration**: Associates the Dockerfiles of each service and loads the .env file.  

### 3. Dockerfiles
There is one for each service inside srcs/requirements/service/. Defines what is "inside" each container.  

**Operating System**: this will state the base image used for the container (Debian or Alpine). Number of version must be specified in orther to not get the latest.  

**Software**: Installation of packages (e.g., mariadb-server, php-fpm, nginx). In alpine is used `apk add` instead of `apt-get install` from debian.  The `--no-cache` flag is used as a good practice in Alpine to keep the image lightweight, avoiding storing the package index in the container cache.  

**Specifications**: each container has its own needs, some need copies of files into specific folders of the container and even need a modification.

**Expose**: It's just documentation. It tells other developers: 'this container is designed to listen on this port'. An actual expose of a port is done only for nginx, and is done in the docker-compose.yml.

**Execution**: The final command that keeps the container alive (e.g., `mysqld_safe` or `nginx -g daemon off;`). In this case every dokerfiel calls its own script.sh.

### 4. Data and Security
**Variables (.env)**: stores database names and users. No .env is giving, instead a .env.example is provided for the .env contruction.  

**Secrets (secrets/)**: Folder in the root for critical passwords that should never be uploaded to Git. No secrets are provided, they are to me created in a secrets folder in the same level as the makefile.  

**Volumes**: The actual data lives on the host in /home/login/data and Docker "connects" them to the internal folders of the containers.  

# Commands to manage the containers and volumes
**Service Status**: `docker ps` (Should show the three containers with status "Up").  

**Network Isolation**: `docker network inspect inception` (Should confirm that only NGINX has external exposure).  

**TLS Verification**: `openssl s_client -connect lgracia-.42.fr:443 -tls1_2` (Validates that the TLSv1.2 protocol is accepted and the certificate is correct).  

**Volúmenes Nombrados**: Confirma con docker volume ls que existen los dos volúmenes requeridos.  

**Initialization Monitoring**: `docker-compose logs -f` (Allows auditing the execution of the `entrypoint.sh` scripts and user creation). Also `docker logs container_name`.  

**Enter container**: `docker exec -it container-name sh`.  

**Databases**: `show databases;`, `select ... from sys.databases;`.

**Auto-restart**: Stop a container manually `docker stop srcs-wordpress-1` and check with docker ps that it restarts automatically after a few seconds

# Project data & persistence
There are two volumes for persistence, on for mariadb and another for wordpress, nginx has access to this one as well.
For Docker to store data in the specific host path (/home/lgracia-/data/...) using named volumes, this technical syntax is required:
- `driver: local`: Indicates that the volume will use the standard local storage driver of your machine.
- `driver_opts`: These are advanced options to tell the driver exactly how to behave.
type: none: Specifies that we do not want a special file system (like NFS); just a direct mount.
- `o: bind`: Instructs Docker to perform a "bind mount," that is, to link a host folder with the volume.
- `device: /home/lgracia-/data/...`: The absolute path on your host machine where the files will actually be written so they are not deleted when containers are stopped. In this case is the one indicated in the subject.
