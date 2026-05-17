This document focuses on how the project is used and is free of technical implementation details and focuses on the operability of the service
# Services are provided by the stack.
# Start and stop the project.
1. Build and start: `make`
2. Access the site:
    - Web: https://lgracia-.42.fr
    - Admin: https://lgracia-.42.fr/wp-admin/
Stop the containers: `make down`
Restart the containers: `make up`
Clean the containers:  `make clean`
Total cleans of the conatiners: `make prune`
# Access the website and the administration panel.
# Locate and manage credentials.
# Service command verification
**Service Status**: `docker ps` (Should show the three containers with status "Up").  
**Network Isolation**: `docker network inspect inception` (Should confirm that only NGINX has external exposure).  
**TLS Verification**: `openssl s_client -connect localhost:443 -tls1_2` (Validates that the TLSv1.2 protocol is accepted and the certificate is correct).  
**Initialization Monitoring**: `docker-compose logs -f` (Allows auditing the execution of the `entrypoint.sh` scripts and user creation).
**Enter container**: `docker exec -it container-name sh`.
**Databases**: `show databases;`, `select ... from sys.databases;`.