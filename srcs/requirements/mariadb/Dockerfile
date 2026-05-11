FROM alpine:3.22

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chmod 777 /run/mysqld

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306
ENTRYPOINT ["sh", "/setup.sh"]