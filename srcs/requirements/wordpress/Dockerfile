FROM alpine:3.22

WORKDIR /var/www/html

RUN apk update && apk add --no-cache php-fpm php-mysqli \
	php-iconv php-json php-mbstring php-ctype php-phar curl \
	mariadb-client

RUN mkdir -p /run/php \
	&& addgroup -S www-data 2>/dev/null || true \
	&& adduser -S www-data -G www-data 2>/dev/null || true

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php83/php-fpm.d/www.conf
RUN sed -i 's/user = nobody/user = www-data/g' /etc/php83/php-fpm.d/www.conf
RUN sed -i 's/group = nobody/group = www-data/g' /etc/php83/php-fpm.d/www.conf

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["sh", "/setup.sh"]