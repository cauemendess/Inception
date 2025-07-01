FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y php8.2-fpm php8.2-mysql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


CMD ["php-fpm8.2", "-F"]