FROM debian:buster

RUN apt-get update && \
    apt-get install -y php7.3-fpm php7.3-mysql wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configura o PHP-FPM para escutar em todas as interfaces
RUN sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/' /etc/php/7.3/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["php-fpm7.3", "-F"]