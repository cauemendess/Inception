FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y php8.2-fpm php8.2-mysqli curl mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/.

COPY ./tools/script.sh .

RUN chmod +x script.sh

CMD ["./script.sh"]