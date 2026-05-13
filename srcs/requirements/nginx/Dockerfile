FROM alpine:3.22

RUN apk update && apk add --no-cache nginx openssl \
	&& openssl req -x509 -nodes -days 365 -newkey \
	rsa:2048 -keyout \
	/etc/ssl/private/nginx.key -out \
	/etc/ssl/certs/nginx.crt -subj "/C=ES/ST=S/L=S/O=42/OU=42/CN=lgracia-.42.fr"

RUN addgroup -S www-data 2>/dev/null || true \
	&& adduser -S www-data -G www-data 2>/dev/null || true

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 443

ENTRYPOINT ["sh", "/setup.sh"]