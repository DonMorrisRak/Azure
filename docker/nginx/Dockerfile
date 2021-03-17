FROM alpine:latest
RUN apk add nginx
COPY default.conf /etc/nginx/conf.d/default.conf
COPY index.html /var/www/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN echo "pid /tmp/nginx.pid;" >> /etc/nginx/nginx.conf
EXPOSE 80
CMD ["/usr/sbin/nginx"]
