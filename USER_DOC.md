This document focuses on how the project is used and is free of technical implementation details and focuses on the operability of the service
# Services provided by the stack
Here is a simple explanation of the three mandatory services that will be built.  

* **NGINX**: It is the "guardian" or gateway. It is a web server that receives requests from users over the internet. In this project, it is the only allowed access point and uses security protocols (TLS v1.2 or v1.3) so that the connection is encrypted and secure.  

**WordPress** (+ PHP-FPM): It is the "heart" of the site. It is the system that manages the content of the website. Since WordPress is written in PHP, it needs a tool called PHP-FPM to process that code and convert it into the pages that the user sees.  

**MariaDB**: It is the "storage" or database. This is where all the important information is kept: texts, users, and passwords. WordPress cannot function without connecting to MariaDB to read and save its data.

# Start and stop the project
1. Build and start: `make`
2. Access the site:
    - Web: https://lgracia-.42.fr
    - Admin: https://lgracia-.42.fr/wp-admin/
Stop the containers: `make down`
Restart the containers: `make up`
Clean the containers:  `make clean`
Total cleans of the conatiners: `make prune`

# Access the website and the administration panel
Afte the built you can open the browser and go to either the website or the administration panel:
    - Web: https://lgracia-.42.fr
    - Admin: https://lgracia-.42.fr/wp-admin/
    
# Locate and manage credentials
For security, no passwords are stored in the repository:
1.  **Environment Variables**: General settings are located in `srcs/.env`.  
2.  **Secrets**: Sensitive passwords (database root, database user, wp-admin) are stored in the `secrets/` directory on the host.  
3.  **Inside Containers**: Secrets are mounted at `/run/secrets/`.

# Service command verification
**Service Status**: `docker ps` (Should show the three containers with status "Up"). Only the NGINX container should show a mapping to the host (e.g., 0.0.0.0:443->443/tcp). The WordPress and MariaDB containers should show their internal ports (9000 and 3306) without a host mapping.  

**Network Isolation**: `docker network inspect inception` (Should confirm that only NGINX has external exposure).  

**TLS Verification**: `openssl s_client -connect lgracia-.42.fr:443 -tls1_2` (Validates that the TLSv1.2 protocol is accepted and the certificate is correct).  Although, this one shoud fail `openssl s_client -connect lgracia-.42.fr:443 -tls1_1`.

**Volúmenes Nombrados**: Confirma con `docker volume ls` que existen los dos volúmenes requeridos.  

**Initialization Monitoring**: `docker-compose logs -f` (Allows auditing the execution of the `entrypoint.sh` scripts and user creation). Also `docker logs container_name`.  

**Enter container**: `docker exec -it container-name sh`.  

**Databases**: `show databases;`,  `use wordpress_db`, `select user_login from wp_users;`.

**Auto-restart**: Stop a container manually `docker stop srcs-wordpress-1` and check with docker ps that it restarts automatically after a few seconds

**No access through HTTP**: `curl -I http://lgracia-.42.fr`, `telnet lgracia-.42.fr 80`, this must show `Connection refused` or similar, indicating NGINX isn't listenning port 80.



