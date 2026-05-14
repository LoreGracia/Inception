FROM alpine:3.22

RUN apk update && apk add --no-cache mariadb mariadb-client

# COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
RUN sed -i 's/skip-networking/# skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chmod 777 /run/mysqld

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306
ENTRYPOINT ["sh", "/setup.sh"]