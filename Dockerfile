FROM ubuntu:15.10

# NGINX
RUN \
  apt-get update && \
  apt-get install -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# PHP
RUN apt-get install -y wget build-essential libxml2-dev bzip2
RUN cd /tmp && wget http://us2.php.net/get/php-5.6.14.tar.bz2/from/this/mirror -O php-5.6.14.tar.bz2
RUN cd /tmp && tar -xjvf php-5.6.14.tar.bz2 && \
    cd php-5.6.14 && ./configure --enable-fpm --with-mysql && make && make install && \
    cp sapi/fpm/php-fpm /usr/local/bin

# Configs
ADD config/nginx-sites-enabled-default /etc/nginx/sites-available/default
ADD config/php.ini /usr/local/php/php.ini
ADD config/php-fpm.conf /usr/local/etc/php-fpm.conf
ADD start.sh /start.sh

VOLUME /var/www/html

EXPOSE 80

ENTRYPOINT ["/start.sh"]
