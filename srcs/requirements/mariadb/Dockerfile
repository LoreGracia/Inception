FROM alpine:3.22

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306
ENTRYPOINT ["sh", "/setup.sh"]