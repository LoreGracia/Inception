This document is intended for someone who wants to understand the internal architecture or modify the code
# Set up the environment from scratch (prerequisites, configuration files, secrets).
## Virtual Machine
## Configuration file
## Secrets
## Environment
Follow the `.env.example` is to create the `.env` needed for the proyect. Do no use admin in the WP user name.
# Build and launch the project.
Just use `make` in the folder respository after setting the previous section.
## How it works
1. Makefile
It is the file in the root of the project that automates everything. It does not contain container configuration, but commands to call Docker Compose.
*Content*: Rules like all, build, down, up, clean, fclean, prune and re.
*Function*: Execute docker-compose commands in a simplified way.

2. Docker-compose.yml
It is thte file called by the makefile. It is located inside the srcs/ folder. Defines the "map" of how the services relate.
*Services*: Defines a mariadb, wordpress, and nginx.
*Networks*: Creates the internal network (e.g., inception) so that they can communicate with each other.
*Named Volumes*: Registers mariadb_data and wordpress_data.
*Configuration*: Associates the Dockerfiles of each service and loads the .env file.

3. Dockerfiles
There is one for each service inside srcs/requirements/<service>/. Defines what is "inside" each container.
*Operating System*: Base image (Debian or Alpine).
*Software*: Installation of packages (e.g., mariadb-server, php-fpm, nginx).
*Execution*: The final command that keeps the container alive (e.g., mysqld_safe or nginx -g daemon off;)

4. Data and Security
*Variables (.env)*: Located in srcs/, stores database names and users.
*Secrets (secrets/)*: Folder in the root for critical passwords that should never be uploaded to Git.
*Volumes*: The actual data lives on the host in /home/login/data and Docker "connects" them to the internal folders of the containers.

# Use relevant commands to manage the containers and volumes.
# Project data & persistence
There are two volumes for persistence, on for mariadb and another for wordpress, nginx has access to this one as well.
For Docker to store data in the specific host path (/home/lgracia-/data/...) using named volumes, this technical syntax is required:
- `driver: local`: Indicates that the volume will use the standard local storage driver of your machine.
- `driver_opts`: These are advanced options to tell the driver exactly how to behave.
type: none: Specifies that we do not want a special file system (like NFS); just a direct mount.
- `o: bind`: Instructs Docker to perform a "bind mount," that is, to link a host folder with the volume.
- `device: /home/lgracia-/data/...`: The absolute path on your host machine where the files will actually be written so they are not deleted when containers are stopped. In this case is the one indicated in the subject.
