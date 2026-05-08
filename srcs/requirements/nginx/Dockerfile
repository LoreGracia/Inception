FROM alpine:3.22

RUN apk update && apk add --no-cache nginx openssl && openssl 

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]